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

**Windows (PowerShell)**
```powershell
# Download the OPA binary
Invoke-WebRequest -Uri "https://github.com/open-policy-agent/opa/releases/download/v0.68.0/opa_windows_amd64.exe" `
  -OutFile "$env:USERPROFILE\opa.exe"

# Move it somewhere on your PATH, e.g. C:\Program Files\opa\
New-Item -ItemType Directory -Force -Path "C:\Program Files\opa"
Move-Item "$env:USERPROFILE\opa.exe" "C:\Program Files\opa\opa.exe"

# Add to PATH for the current session (or set it permanently in System Settings)
$env:PATH += ";C:\Program Files\opa"
```

**Windows (winget)**
```powershell
winget install OpenPolicyAgent.OPA
```

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

**macOS / Linux**
```bash
go build -o opatutor ./cmd/opatutor
```

**Windows (PowerShell)**
```powershell
go build -o opatutor.exe .\cmd\opatutor
```

> **Tip (macOS / Linux):** move the binary somewhere on your `PATH`:
> ```bash
> mv opatutor /usr/local/bin/
> ```

> **Tip (Windows):** move the binary somewhere on your `PATH`, or run it from the
> current directory using `.\opatutor.exe`:
> ```powershell
> # Option A — run from the repo root (no PATH change needed)
> .\opatutor.exe list
>
> # Option B — copy to a folder already on your PATH, e.g. C:\Program Files\opatutor\
> New-Item -ItemType Directory -Force -Path "C:\Program Files\opatutor"
> Copy-Item opatutor.exe "C:\Program Files\opatutor\"
> # Then add C:\Program Files\opatutor to your PATH in System Settings
> ```

> **Windows note:** The examples below use `opatutor`. On Windows substitute
> `opatutor.exe` (or `.\opatutor.exe` if it isn't on your `PATH`).

### How It Works

Every exercise is a directory containing:

```
exercises/<section>/<nn>_<name>/
├── <name>.rego          ← the policy file YOU edit (has TODO comments)
├── <name>_test.rego     ← tests that verify your work (do NOT edit)
└── data.json            ← static data used by the policy (optional, do NOT edit)
```

Your goal for each exercise: **read the TODO comments in the `.rego` policy file, write the missing rules, and make all the tests pass.**

### Step-by-Step Workflow

#### 1. See what's ahead

```bash
opatutor list
```

This shows every exercise with a ✓ (complete) or ○ (incomplete) marker. Exercises are ordered by topic — start at the top.

#### 2. Start the next exercise

```bash
opatutor next
```

This finds the first incomplete exercise, runs its tests, and shows you which ones pass and fail. On a fresh start everything will fail — that's expected.

#### 3. Open the policy file and read the comments

Open the `.rego` file for the exercise (not the `_test.rego` file). At the top you'll find:

- An **overview** of the concept being taught
- A link to the relevant **OPA documentation**
- The **input structure** the tests will provide
- **Example inputs and expected results**
- Numbered **tasks** describing exactly what you need to write

Below the tasks you'll see commented-out scaffolding that hints at the shape of each solution:

```rego
# TODO 1: declare allow with a default of false
# default allow := ...

# TODO 2: write allow — look up the user's role in data.permissions
# allow if {
#     ...
# }
```

The scaffold matches the form of the expected solution — if it shows `name := ...` you're writing a simple assignment; if it shows `name if { ... }` you're writing a conditional rule.

#### 4. Write your solution

Uncomment or rewrite the scaffolded block, replacing `...` with real Rego code. Don't touch the **stubs** section at the bottom of the file — those exist to prevent compilation errors while you work and will be shadowed by your rules once you write them.

#### 5. Test your work

```bash
opatutor run policy_language/01_keywords
```

Or just run `opatutor next` again — it re-runs the same exercise until all tests pass.

You'll see per-test results:

```
  ✓  admin_is_allowed
  ✗  viewer_is_denied
  ✓  mfa_required_when_no_mfa

  2 passed · 1 failed  (3 total)

○ Some tests are still failing.
  Open exercises/policy_language/01_keywords and follow the TODO comments.
```

Fix the remaining issues, save the file, and re-run. Iterate until you see:

```
✓ All tests passed! Exercise complete.
```

#### 6. Move on

```bash
opatutor next
```

This skips completed exercises and jumps to the next one.

#### 7. Check overall progress at any time

```bash
opatutor verify
```

This runs every exercise and refreshes your progress file.

### Tips

- **Read the tests.** The `_test.rego` file shows exactly what inputs will be provided and what outputs are expected. You don't edit it, but it's a great reference.
- **Use the OPA docs.** Each exercise header links to the relevant documentation page.
- **Format on save.** If you're using VSCode with the OPA extension, your files are auto-formatted whenever you save.
- **Reset an exercise.** If your progress gets out of sync, clear one exercise and try again:
  ```bash
  opatutor reset policy_language/01_keywords
  ```

---

## CLI Reference

| Command | Description |
|---|---|
| `opatutor list` | List all exercises with ✓ / ○ status |
| `opatutor next` | Find and run the next incomplete exercise |
| `opatutor run <slug>` | Run tests for one exercise by its slug (e.g. `policy_language/01_keywords`) |
| `opatutor run-all` | Run every exercise in order with detailed per-test results |
| `opatutor verify` | Run all exercises quietly and update progress |
| `opatutor reset <slug>` | Clear the completion status of one exercise |

Progress is stored in `~/.config/opatutor/progress.json`.

---

## Exercise Curriculum

### Policy Language

| # | Exercise | Topic |
|---|---|---|
| 01 | `policy_language/01_keywords` | `default`, `not`, `if` |
| 02 | `policy_language/02_variables` | Variables and implicit iteration |
| 03 | `policy_language/03_rules` | Complete rules vs. partial rules |
| 04 | `policy_language/04_builtins_strings` | String built-ins |
| 05 | `policy_language/05_builtins_arrays` | Array built-ins |
| 06 | `policy_language/06_data_and_input` | `data` vs `input` document model |
| 07 | `policy_language/07_builtins_sets` | Set operations |
| 08 | `policy_language/08_composition` | Importing one policy into another |
| 09 | `policy_language/09_and_or_logic` | AND / OR logic patterns |
| 10 | `policy_language/10_every_some` | `every` and `some` keywords |
| 11 | `policy_language/11_comprehensions` | Array, set, and object comprehensions |
| 12 | `policy_language/12_functions` | User-defined functions |
| 13 | `policy_language/13_negation` | Negation-as-failure and `else` |

### Use Cases

| # | Exercise | Topic |
|---|---|---|
| 14 | `usecases/01_data_filtering` | Partial evaluation / filtered datasets |
| 15 | `usecases/02_docker` | Docker authorization plugin |
| 16 | `usecases/03_rbac` | Role-Based Access Control (RBAC) |

### OPA Tooling

| # | Exercise | Topic |
|---|---|---|
| 17 | `opa_tooling/01_testing` | Writing and fixing OPA tests |
| 18 | `opa_tooling/02_bundling` | `opa build` / `opa inspect` bundles |

---

## Development Setup (VSCode)

1. Install the recommended extensions when prompted, or install them manually:
   - **OPA** (`open-policy-agent.opa`) — syntax highlighting, formatting, and inline evaluation for `.rego` files
   - **Go** (`golang.go`) — Go language support for the CLI tool

2. Open the repository root in VSCode:
   ```bash
   code .
   ```

3. **Edit → Save → Test** — the included settings enable format-on-save for `.rego` files via the OPA extension, so your code is always cleanly formatted.

4. Use the pre-configured **launch configurations** (press `F5` or open **Run and Debug**):

   | Configuration | What it does |
   |---|---|
   | **OPA: Test current exercise** | Runs `opatutor run` for the exercise whose file is currently open |
   | **OPA: List all exercises** | Runs `opatutor list` |
   | **OPA: Next exercise** | Runs `opatutor next` |
   | **OPA: Verify all exercises** | Runs `opatutor verify` |

5. A `.regal/config.yaml` is included to suppress linter warnings that are intentional in a learning context (TODO comments, stub rules, etc.). If you use Regal for linting, it will pick this up automatically.

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
└── data.json            # base data (optional) — never edited by the student
```

Rules:
- The broken starting state must make at least one test fail.
- The test file must never need to be edited (except in `opa_tooling/01_testing`, which teaches testing).
- Each `TODO` comment must clearly explain *what* to change, not *what the answer is*.
- TODO scaffolding must match the syntactic form of the expected solution — use `name := ...` for direct assignments, `name if { ... }` for conditional rules.
- Policy content must be original — do not reproduce examples from the OPA documentation.
- **Data portability:** If an exercise uses `data.json`, tests **must** inject mock data with `with data.<key> as mock_<key>` on every assertion. This ensures tests work both via the CLI (`opa test <dir>`) and VSCode's OPA test runner (which uses a different data root). Define mock data constants at the top of the test file, mirroring the contents of `data.json`.

