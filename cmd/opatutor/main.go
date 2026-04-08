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

// runOPATest runs `opa test <dir>` and returns (passed, output, error).
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
	fmt.Printf("\n%s %s\n", bold("Running:"), cyan(ex.Title))
	fmt.Printf("%s %s\n\n", bold("Directory:"), ex.Dir)

	ok, output, err := runOPATest(ex.Dir)
	if err != nil {
		fmt.Println(red("Error running opa test:"), err)
		fmt.Println(output)
		return nil
	}

	fmt.Print(output)

	p, _ := exercise.LoadProgress(progPath)
	if p == nil {
		p, _ = exercise.LoadProgress(progPath)
	}

	if ok {
		p.Mark(ex.Slug, true)
		_ = p.Save()
		fmt.Println(green("\n✓ All tests passed! Exercise complete.\n"))
	} else {
		p.Mark(ex.Slug, false)
		_ = p.Save()
		fmt.Println(yellow("\n○ Some tests are still failing."))
		fmt.Printf("  Open %s and follow the TODO comments.\n\n", cyan(ex.Dir))
	}
	return nil
}

func main() {
	if err := newRootCmd().Execute(); err != nil {
		os.Exit(1)
	}
}
