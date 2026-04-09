package main

import (
	"fmt"
	"os"
	"os/exec"
	"path/filepath"
	"runtime"
	"strings"

	"github.com/emagers/opatutor/internal/exercise"
	"github.com/spf13/cobra"
)

const progressFile = ".opatutor-progress.json"

// resolveExercisesRoot finds the exercises/ directory relative to the binary,
// then relative to the working directory as a fallback.
func resolveExercisesRoot() string {
	// 1. Look relative to the executable (installed binary).
	if exe, err := os.Executable(); err == nil {
		candidate := filepath.Join(filepath.Dir(exe), "exercises")
		if fi, err := os.Stat(candidate); err == nil && fi.IsDir() {
			return candidate
		}
	}
	// 2. Look relative to the current working directory (repo checkout / go run).
	if wd, err := os.Getwd(); err == nil {
		candidate := filepath.Join(wd, "exercises")
		if fi, err := os.Stat(candidate); err == nil && fi.IsDir() {
			return candidate
		}
	}
	return "exercises"
}

func progressPath() string {
	if home, err := os.UserHomeDir(); err == nil {
		return filepath.Join(home, ".config", "opatutor", "progress.json")
	}
	return progressFile
}

// colorize returns ANSI-colored text when the terminal supports it.
func colorize(code, text string) string {
	if runtime.GOOS == "windows" {
		return text
	}
	return "\033[" + code + "m" + text + "\033[0m"
}

func green(s string) string  { return colorize("32", s) }
func yellow(s string) string { return colorize("33", s) }
func red(s string) string    { return colorize("31", s) }
func bold(s string) string   { return colorize("1", s) }
func cyan(s string) string   { return colorize("36", s) }
func dim(s string) string    { return colorize("2", s) }

// runOPATest runs `opa test <dir> -v` and returns (allPassed, output, error).
func runOPATest(dir string) (bool, string, error) {
	cmd := exec.Command("opa", "test", dir, "-v")
	out, err := cmd.CombinedOutput()
	output := string(out)
	if err != nil {
		// Exit code 2 means tests ran but some failed — that's not a tool error.
		if exitErr, ok := err.(*exec.ExitError); ok && exitErr.ExitCode() == 2 {
			return false, output, nil
		}
		return false, output, err
	}
	return true, output, nil
}

// ── OPA output parsing & colorizing ─────────────────────────────────────────

// testResult holds one parsed OPA test outcome.
type testResult struct {
	name   string // short name with "test_" prefix removed
	passed bool
}

// parseTestResults extracts individual test results from the SUMMARY section
// of `opa test -v` output.
func parseTestResults(output string) []testResult {
	var results []testResult
	inSummary := false
	for _, line := range strings.Split(output, "\n") {
		t := strings.TrimSpace(line)
		if t == "SUMMARY" {
			inSummary = true
			continue
		}
		if !inSummary {
			continue
		}
		if !strings.HasPrefix(t, "data.") {
			continue
		}
		passed := strings.Contains(t, ": PASS")
		failed := strings.Contains(t, ": FAIL")
		if !passed && !failed {
			continue
		}
		colonIdx := strings.Index(t, ": ")
		if colonIdx < 0 {
			continue
		}
		parts := strings.Split(t[:colonIdx], ".")
		shortName := strings.TrimPrefix(parts[len(parts)-1], "test_")
		results = append(results, testResult{name: shortName, passed: passed})
	}
	return results
}

// colorizeOPAOutput adds ANSI color to raw `opa test -v` text output.
// It reformats test-result lines, colors section headers, dims trace lines,
// and highlights the final PASS/FAIL counts.
func colorizeOPAOutput(output string) string {
	var sb strings.Builder
	section := "" // "", "failures", "summary"

	for _, line := range strings.Split(output, "\n") {
		t := strings.TrimSpace(line)

		// ── Section markers ──────────────────────────────────────────────
		switch t {
		case "FAILURES":
			section = "failures"
			sb.WriteString("\n" + bold(red("Failures")) + "\n")
			continue
		case "SUMMARY":
			section = "summary"
			sb.WriteString("\n" + bold("Summary") + "\n")
			continue
		}

		// ── Separator lines ──────────────────────────────────────────────
		if strings.HasPrefix(t, "--------") {
			sb.WriteString(dim(line) + "\n")
			continue
		}

		// ── Test result lines: "data.pkg.test_foo: PASS (78µs)" ─────────
		if strings.HasPrefix(t, "data.") &&
			(strings.Contains(t, ": PASS") || strings.Contains(t, ": FAIL")) {

			colonIdx := strings.Index(t, ": ")
			if colonIdx < 0 {
				sb.WriteString(line + "\n")
				continue
			}
			parts := strings.Split(t[:colonIdx], ".")
			shortName := strings.TrimPrefix(parts[len(parts)-1], "test_")
			rest := t[colonIdx+2:]

			dur := ""
			if pi := strings.Index(rest, "("); pi >= 0 {
				dur = dim(rest[pi:])
			}

			isPass := strings.HasPrefix(rest, "PASS")

			switch {
			case section == "failures":
				// Failure section: test name is the header before its trace.
				sb.WriteString(fmt.Sprintf("\n  %s  %s  %s\n",
					red("✗"), bold(red(shortName)), dur))
			case isPass:
				sb.WriteString(fmt.Sprintf("  %s  %-52s %s\n",
					green("✓"), shortName, dur))
			default:
				sb.WriteString(fmt.Sprintf("  %s  %-52s %s\n",
					red("✗"), red(shortName), dur))
			}
			continue
		}

		// ── Final count lines ────────────────────────────────────────────
		if strings.HasPrefix(t, "PASS:") {
			sb.WriteString("  " + green(bold(t)) + "\n")
			continue
		}
		if strings.HasPrefix(t, "FAIL:") {
			sb.WriteString("  " + red(bold(t)) + "\n")
			continue
		}

		// ── File-path headers inside SUMMARY ────────────────────────────
		if strings.HasSuffix(t, ".rego:") {
			sb.WriteString("  " + cyan(t) + "\n")
			continue
		}

		// ── OPA compile/runtime error lines ─────────────────────────────
		if strings.HasPrefix(t, "rego_") || strings.Contains(t, "errors occurred") {
			sb.WriteString(red(line) + "\n")
			continue
		}

		// ── Indented trace lines (inside a failure block) ────────────────
		if len(line) > 0 && (line[0] == ' ' || line[0] == '\t') && t != "" {
			sb.WriteString(dim(line) + "\n")
			continue
		}

		// ── Everything else (empty lines, misc) ──────────────────────────
		sb.WriteString(line + "\n")
	}

	return strings.TrimRight(sb.String(), "\n")
}

// ── Commands ─────────────────────────────────────────────────────────────────

func newRootCmd() *cobra.Command {
	root := &cobra.Command{
		Use:   "opatutor",
		Short: "An interactive learning tool for OPA and the Rego policy language",
		Long: bold("opatutor") + ` — learn OPA by fixing intentionally broken policy files.

Each exercise lives in its own directory under ` + cyan("exercises/") + `.
Edit the policy file(s) until ` + bold("opa test") + ` passes, then use this
CLI to verify your work and move on.`,
	}

	exercisesRoot := resolveExercisesRoot()

	root.AddCommand(
		newListCmd(exercisesRoot),
		newRunCmd(exercisesRoot),
		newRunAllCmd(exercisesRoot),
		newNextCmd(exercisesRoot),
		newVerifyCmd(exercisesRoot),
		newResetCmd(exercisesRoot),
	)
	return root
}

// ── list ────────────────────────────────────────────────────────────────────

func newListCmd(exercisesRoot string) *cobra.Command {
	return &cobra.Command{
		Use:   "list",
		Short: "List all exercises and their completion status",
		RunE: func(cmd *cobra.Command, args []string) error {
			exercises, err := exercise.All(exercisesRoot)
			if err != nil {
				return fmt.Errorf("loading exercises: %w", err)
			}
			p, err := exercise.LoadProgress(progressPath())
			if err != nil {
				return fmt.Errorf("loading progress: %w", err)
			}

			fmt.Println(bold("\nExercises:"))
			fmt.Println(strings.Repeat("─", 60))
			for i, ex := range exercises {
				var status string
				if p.IsDone(ex.Slug) {
					status = green("✓")
				} else {
					status = yellow("○")
				}
				fmt.Printf(" %s  %2d. %s\n", status, i+1, ex.Title)
				fmt.Printf("        %s\n", cyan(ex.Slug))
			}
			fmt.Println(strings.Repeat("─", 60))

			done := 0
			for _, ex := range exercises {
				if p.IsDone(ex.Slug) {
					done++
				}
			}
			fmt.Printf("\n  %s / %s exercises completed\n\n",
				bold(fmt.Sprintf("%d", done)),
				bold(fmt.Sprintf("%d", len(exercises))),
			)
			return nil
		},
	}
}

// ── run ─────────────────────────────────────────────────────────────────────

func newRunCmd(exercisesRoot string) *cobra.Command {
	return &cobra.Command{
		Use:   "run <exercise-slug>",
		Short: "Run tests for a specific exercise",
		Example: `  opatutor run policy_language/01_keywords
  opatutor run usecases/02_docker`,
		Args: cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			slug := args[0]
			exercises, err := exercise.All(exercisesRoot)
			if err != nil {
				return fmt.Errorf("loading exercises: %w", err)
			}

			var target *exercise.Exercise
			for i := range exercises {
				if exercises[i].Slug == slug {
					target = &exercises[i]
					break
				}
			}
			if target == nil {
				return fmt.Errorf("exercise %q not found — run `opatutor list` to see all exercises", slug)
			}

			return runAndReport(target, progressPath())
		},
	}
}

// ── run-all ──────────────────────────────────────────────────────────────────

func newRunAllCmd(exercisesRoot string) *cobra.Command {
	return &cobra.Command{
		Use:   "run-all",
		Short: "Run every exercise in lesson order with per-file results",
		RunE: func(cmd *cobra.Command, args []string) error {
			exercises, err := exercise.All(exercisesRoot)
			if err != nil {
				return fmt.Errorf("loading exercises: %w", err)
			}
			p, err := exercise.LoadProgress(progressPath())
			if err != nil {
				return fmt.Errorf("loading progress: %w", err)
			}

			totalExercises := len(exercises)
			totalPass, totalFail, exComplete := 0, 0, 0
			sep := strings.Repeat("━", 62)

			for i := range exercises {
				ex := &exercises[i]

				// ── Exercise header ──────────────────────────────────────
				fmt.Printf("\n%s\n", cyan(sep))
				fmt.Printf(" %s  %s\n",
					dim(fmt.Sprintf("[%02d/%02d]", i+1, totalExercises)),
					bold(ex.Title),
				)
				fmt.Printf("         %s\n", dim(ex.Dir))
				fmt.Printf("%s\n\n", cyan(sep))

				ok, output, err := runOPATest(ex.Dir)
				if err != nil {
					fmt.Printf("  %s  %v\n", red("error:"), err)
					p.Mark(ex.Slug, false)
					continue
				}

				results := parseTestResults(output)
				if len(results) == 0 {
					// Likely compile errors — show raw colorized output.
					fmt.Println(colorizeOPAOutput(output))
					p.Mark(ex.Slug, false)
					continue
				}

				// ── Per-test results ─────────────────────────────────────
				pass, fail := 0, 0
				for _, r := range results {
					if r.passed {
						fmt.Printf("  %s  %s\n", green("✓"), r.name)
						pass++
					} else {
						fmt.Printf("  %s  %s\n", red("✗"), red(r.name))
						fail++
					}
				}

				// ── Per-exercise summary ─────────────────────────────────
				total := pass + fail
				complete := ""
				if ok {
					complete = "  " + green("✓ complete")
					exComplete++
				}
				fmt.Printf("\n  %s · %s  (%d total)%s\n",
					green(fmt.Sprintf("%d passed", pass)),
					red(fmt.Sprintf("%d failed", fail)),
					total,
					complete,
				)

				totalPass += pass
				totalFail += fail
				p.Mark(ex.Slug, ok)
			}

			_ = p.Save()

			// ── Overall summary ──────────────────────────────────────────
			fmt.Printf("\n%s\n", strings.Repeat("━", 62))
			fmt.Printf(" %s\n", bold("Overall Results"))
			fmt.Printf("%s\n\n", strings.Repeat("━", 62))
			fmt.Printf("  Exercises:  %s / %d complete\n",
				green(fmt.Sprintf("%d", exComplete)), totalExercises)
			fmt.Printf("  Tests:      %s passed · %s failed  (%d total)\n\n",
				green(fmt.Sprintf("%d", totalPass)),
				red(fmt.Sprintf("%d", totalFail)),
				totalPass+totalFail,
			)
			return nil
		},
	}
}

// ── next ────────────────────────────────────────────────────────────────────

func newNextCmd(exercisesRoot string) *cobra.Command {
	return &cobra.Command{
		Use:   "next",
		Short: "Run the next incomplete exercise",
		RunE: func(cmd *cobra.Command, args []string) error {
			exercises, err := exercise.All(exercisesRoot)
			if err != nil {
				return fmt.Errorf("loading exercises: %w", err)
			}
			p, err := exercise.LoadProgress(progressPath())
			if err != nil {
				return fmt.Errorf("loading progress: %w", err)
			}

			for i := range exercises {
				if !p.IsDone(exercises[i].Slug) {
					return runAndReport(&exercises[i], progressPath())
				}
			}

			fmt.Println(green("\n🎉  All exercises complete! Well done.\n"))
			return nil
		},
	}
}

// ── verify ───────────────────────────────────────────────────────────────────

func newVerifyCmd(exercisesRoot string) *cobra.Command {
	return &cobra.Command{
		Use:   "verify",
		Short: "Run every exercise and update progress",
		RunE: func(cmd *cobra.Command, args []string) error {
			exercises, err := exercise.All(exercisesRoot)
			if err != nil {
				return fmt.Errorf("loading exercises: %w", err)
			}
			p, err := exercise.LoadProgress(progressPath())
			if err != nil {
				return fmt.Errorf("loading progress: %w", err)
			}

			passed, failed := 0, 0
			for i := range exercises {
				ex := &exercises[i]
				ok, _, err := runOPATest(ex.Dir)
				if err != nil {
					fmt.Printf(" %s  %s  (%v)\n", red("✗"), ex.Title, err)
					failed++
					p.Mark(ex.Slug, false)
					continue
				}
				p.Mark(ex.Slug, ok)
				if ok {
					fmt.Printf(" %s  %s\n", green("✓"), ex.Title)
					passed++
				} else {
					fmt.Printf(" %s  %s\n", red("✗"), ex.Title)
					failed++
				}
			}

			_ = p.Save()
			fmt.Printf("\n  %s passed, %s failed\n\n",
				green(fmt.Sprintf("%d", passed)),
				red(fmt.Sprintf("%d", failed)),
			)
			return nil
		},
	}
}

// ── reset ────────────────────────────────────────────────────────────────────

func newResetCmd(exercisesRoot string) *cobra.Command {
	return &cobra.Command{
		Use:   "reset <exercise-slug>",
		Short: "Clear the completion status of an exercise",
		Args:  cobra.ExactArgs(1),
		RunE: func(cmd *cobra.Command, args []string) error {
			slug := args[0]
			p, err := exercise.LoadProgress(progressPath())
			if err != nil {
				return fmt.Errorf("loading progress: %w", err)
			}
			p.Mark(slug, false)
			if err := p.Save(); err != nil {
				return err
			}
			fmt.Printf("Progress for %s cleared.\n", cyan(slug))
			return nil
		},
	}
}

// ── shared helper ────────────────────────────────────────────────────────────

func runAndReport(ex *exercise.Exercise, progPath string) error {
	sep := strings.Repeat("━", 62)
	fmt.Printf("\n%s\n", cyan(sep))
	fmt.Printf(" %s\n", bold(ex.Title))
	fmt.Printf(" %s\n", dim(ex.Dir))
	fmt.Printf("%s\n\n", cyan(sep))

	ok, output, err := runOPATest(ex.Dir)
	if err != nil {
		fmt.Println(red("Error running opa test:"), err)
		fmt.Println(output)
		return nil
	}

	fmt.Println(colorizeOPAOutput(output))
	fmt.Println()

	p, _ := exercise.LoadProgress(progPath)
	if p == nil {
		p, _ = exercise.LoadProgress(progPath)
	}

	if ok {
		p.Mark(ex.Slug, true)
		_ = p.Save()
		fmt.Println(green("✓ All tests passed! Exercise complete.\n"))
	} else {
		p.Mark(ex.Slug, false)
		_ = p.Save()
		fmt.Println(yellow("○ Some tests are still failing."))
		fmt.Printf("  Open %s and follow the TODO comments.\n\n", cyan(ex.Dir))
	}
	return nil
}

func main() {
	if err := newRootCmd().Execute(); err != nil {
		os.Exit(1)
	}
}

