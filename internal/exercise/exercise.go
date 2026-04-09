package exercise

import (
	"encoding/json"
	"os"
	"path/filepath"
	"strings"
)

// Exercise holds metadata about a single exercise.
type Exercise struct {
	// Slug is the directory name, e.g. "policy_language/01_keywords".
	Slug string
	// Title is a human-readable name derived from the directory.
	Title string
	// Dir is the absolute path to the exercise directory.
	Dir string
}

// All returns every exercise in the expected curriculum order by walking the
// exercises/ directory relative to exercisesRoot.
func All(exercisesRoot string) ([]Exercise, error) {
	// Ordered top-level sections.
	sections := []string{"policy_language", "usecases", "opa_tooling"}
	var exercises []Exercise
	for _, section := range sections {
		sectionPath := filepath.Join(exercisesRoot, section)
		entries, err := os.ReadDir(sectionPath)
		if err != nil {
			if os.IsNotExist(err) {
				continue
			}
			return nil, err
		}
		for _, e := range entries {
			if !e.IsDir() {
				continue
			}
			slug := section + "/" + e.Name()
			exercises = append(exercises, Exercise{
				Slug:  slug,
				Title: slugToTitle(slug),
				Dir:   filepath.Join(sectionPath, e.Name()),
			})
		}
	}
	return exercises, nil
}

// slugToTitle converts a slug like "policy_language/01_keywords" into
// "Policy Language / 01 Keywords".
func slugToTitle(slug string) string {
	parts := strings.Split(slug, "/")
	var out []string
	for _, p := range parts {
		words := strings.Split(p, "_")
		var titleWords []string
		for _, w := range words {
			if len(w) == 0 {
				continue
			}
			titleWords = append(titleWords, strings.ToUpper(w[:1])+w[1:])
		}
		out = append(out, strings.Join(titleWords, " "))
	}
	return strings.Join(out, " / ")
}

// Progress tracks which exercises have been completed.
type Progress struct {
	Completed map[string]bool `json:"completed"`
	path      string
}

// LoadProgress loads progress from the given file, creating an empty record
// if the file doesn't exist.
func LoadProgress(path string) (*Progress, error) {
	p := &Progress{
		Completed: make(map[string]bool),
		path:      path,
	}
	data, err := os.ReadFile(path)
	if err != nil {
		if os.IsNotExist(err) {
			return p, nil
		}
		return nil, err
	}
	if err := json.Unmarshal(data, p); err != nil {
		return nil, err
	}
	p.path = path
	return p, nil
}

// Save writes progress to disk.
func (p *Progress) Save() error {
	if err := os.MkdirAll(filepath.Dir(p.path), 0o755); err != nil {
		return err
	}
	data, err := json.MarshalIndent(p, "", "  ")
	if err != nil {
		return err
	}
	return os.WriteFile(p.path, data, 0o644)
}

// Mark marks an exercise as completed or not.
func (p *Progress) Mark(slug string, done bool) {
	p.Completed[slug] = done
}

// IsDone returns true if the exercise has been marked complete.
func (p *Progress) IsDone(slug string) bool {
	return p.Completed[slug]
}
