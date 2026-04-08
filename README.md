# opatutor

An interactive, hands-on learning tool for [OPA](https://www.openpolicyagent.org/) and the Rego policy language — inspired by [rustlings](https://github.com/rust-lang/rustlings).

Each exercise is a small, intentionally broken policy file. Read the comments, fix the code, run the tests, and move on.

---

## Table of Contents

- [Prerequisites](#prerequisites)
- [Quick Start](#quick-start)
- [CLI Reference](#cli-reference)
- [Exercise Curriculum](#exercise-curriculum)
- [Development Setup (VSCode)](#development-setup-vscode)
- [Other IDE Support](#other-ide-support)
- [Contributing](#contributing)

---

## Prerequisites

### 1 — Install the OPA CLI

**macOS (Homebrew)**
```bash
brew install opa
```

**Linux / WSL**
```bash
curl -L -o /usr/local/bin/opa \
  https://github.com/open-policy-agent/opa/releases/download/v0.68.0/opa_linux_amd64_static
chmod +x /usr/local/bin/opa
```

**Windows**
Download the latest release from the [OPA releases page](https://github.com/open-policy-agent/opa/releases) and add it to your `PATH`.

Verify:
```bash
opa version
```

### 2 — Install Go 1.21+

Download from [go.dev/dl](https://go.dev/dl/) or use your system package manager.

Verify:
```bash
go version
```

### 3 — Clone this repository

```bash
git clone https://github.com/emagers/opatutor.git
cd opatutor
```

---

## Quick Start

### Build the `opatutor` CLI

```bash
go build -o opatutor ./cmd/opatutor
```

> **Tip (macOS / Linux):** move the binary somewhere on your `PATH`:
> ```bash
> mv opatutor /usr/local/bin/
> ```

### Start learning

```bash
# See all exercises and your current progress
opatutor list

# Jump straight to the first incomplete exercise
opatutor next

# Run tests for a specific exercise
opatutor run policy_language/01_keywords

# Re-run every exercise and refresh progress
opatutor verify
```

---

## CLI Reference

| Command | Description |
|---|---|
| `opatutor list` | List all exercises with ✓ / ○ status |
| `opatutor next` | Find and run the next incomplete exercise |
| `opatutor run <slug>` | Run tests for one exercise by its slug |
| `opatutor verify` | Run all exercises and update progress |
| `opatutor reset <slug>` | Clear the completion status of one exercise |

Progress is stored in `~/.config/opatutor/progress.json`.

---

## Exercise Curriculum

### Policy Language

| # | Exercise | Topic |
|---|---|---|
| 01 | `policy_language/01_keywords` | `default`, `not`, `if` |
| 02 | `policy_language/02_variables` | Variables and implicit iteration |
| 03 | `policy_language/03_rules` | Complete rules vs. partial set rules |
| 04 | `policy_language/04_builtins_strings` | String built-ins |
| 05 | `policy_language/05_builtins_arrays` | Array built-ins |
| 06 | `policy_language/06_data_and_input` | `data` vs `input` document model |
| 07 | `policy_language/07_builtins_sets` | Set operations and comprehensions |
| 08 | `policy_language/08_composition` | Importing one policy into another |

### Use Cases

| # | Exercise | Topic |
|---|---|---|
| 09 | `usecases/01_data_filtering` | Partial evaluation / filtered datasets |
| 10 | `usecases/02_docker` | Docker authorization plugin |

### OPA Tooling

| # | Exercise | Topic |
|---|---|---|
| 11 | `opa_tooling/01_testing` | Writing and fixing OPA tests |
| 12 | `opa_tooling/02_bundling` | `opa build` / `opa inspect` bundles |

---

## Development Setup (VSCode)

1. Install the recommended extensions when prompted, or install them manually:
   - **OPA** (`open-policy-agent.opa`) — syntax highlighting, formatting, and inline evaluation for `.rego` files
   - **Go** (`golang.go`) — Go language support for the CLI tool

2. Open the repository root in VSCode:
   ```bash
   code .
   ```

3. Use the pre-configured **launch configurations** (`.vscode/launch.json`):

   | Configuration | What it does |
   |---|---|
   | **OPA: Test current exercise** | Runs `opatutor run` for the exercise whose file is currently open |
   | **OPA: List all exercises** | Runs `opatutor list` |
   | **OPA: Next exercise** | Runs `opatutor next` |
   | **OPA: Verify all exercises** | Runs `opatutor verify` |

   Press `F5` (or open the **Run and Debug** panel) to choose a configuration and launch it in the integrated terminal.

4. The `.vscode/settings.json` enables format-on-save for `.rego` files using the OPA extension.

---

## Other IDE Support

OPA has community support for several other editors. See the [OPA editor support documentation](https://www.openpolicyagent.org/docs/latest/editor-and-ide-support/) for setup guides covering:

- **JetBrains IDEs** (IntelliJ IDEA, GoLand, etc.)
- **Vim / Neovim**
- **Emacs**

---

## Contributing

Exercises follow a simple three-file convention:

```
exercises/<section>/<nn>_<name>/
├── <name>.rego          # intentionally broken policy — student edits this
├── <name>_test.rego     # tests — never edited by the student
└── data.json            # base data (optional) — may also need fixing
```

Rules:
- The broken starting state must make at least one test fail.
- The test file must never need to be edited.
- Each `TODO` comment must clearly explain *what* to change, not *what the answer is*.
- Policy content must be original — do not reproduce examples from the OPA documentation.

