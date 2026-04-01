# designlens

[![Tests](https://github.com/ropensci-review-tools/designlens/actions/workflows/tests.yml/badge.svg)](https://github.com/ropensci-review-tools/designlens/actions/workflows/tests.yml)

A planning tool with a long memory for AI-assisted projects. {designlens}
works in two directions: **forward**, to guide what you're building next, and
**backward**, to record why you built it the way you did.

Generative AI coding tools implement whatever seems reasonable in the moment.
Without structure, they drift, forget what was decided, repeat questions, or
confidently solve the wrong problems. {designlens} gives agents a spine. You
write down what you want to build and why; {designlens} turns that into concrete
tasks and keeps a record of every decision along the way.

Although {designlens} is especially suited to software projects, it works for any
project where an AI agent helps produce deliverables—documentation, data
pipelines, research workflows, and more.

## Two directions

### Forward: intent-first development

{designlens} starts with intent. Before the agent writes anything, you produce a
plan that captures goals, approach, and open questions. That plan drives task
breakdown and implementation—keeping the agent focused on what was actually
decided, not just what's easiest.

### Backward: design history

Unlike most planning tools, {designlens} also looks backward. After each stage,
it generates a `design-decisions.md` that records what was decided, what was
traded off, and how the decision connects to prior stages. These documents
accumulate in `specs/` as a permanent, human-readable archaeological record of
your project's evolution—so future contributors understand not just *what* was
built, but *why* it is the way it is.

## What it produces

Each feature or change is developed as a numbered *stage*. A stage produces four
artifacts, committed to your repo under `specs/`:

- [**plan.md**](https://github.com/ropensci-review-tools/designlens/blob/main/docs/workflow.md#phase-2-plan-the-stage) — the design vision: what you're building and why
- [**tasks.md**](https://github.com/ropensci-review-tools/designlens/blob/main/docs/workflow.md#phase-3-convert-plan-into-tasks) — the execution breakdown: concrete, checkboxed steps
- [**design-decisions.md**](https://github.com/ropensci-review-tools/designlens/blob/main/docs/workflow.md#phase-5-create-retrospective) — the reasoning record: what was decided, what was traded off, how it connects to prior stages
- **.metadata.json** — session stats accumulated across every session that touched the stage: token usage, lines written, files changed, and which agent(s) did the work

Over time, `specs/` becomes a navigable record of your project's decisions,
readable by contributors who might not have been there when the choices were
made.

## Installation

These installation steps install a small handful of system-level scripts which
tell {designlens} what to do. You can run `designlens uninstall` at any time to
remove them.

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.ps1 | iex
```

## How to use designlens

{designlens} is built for agent CLI environments like
[opencode](https://opencode.ai) or [Claude
Code](https://claude.com/product/claude-code), and can also be used with any
other agent that supports Markdown-based slash or prompt commands. Most
commands are instructions you give your agent, not things you type in a shell
yourself. When an agent runs a {designlens} command, it receives instructions
telling it exactly what to do next—read this file, populate these fields,
generate that document. The agent does the work; {designlens} keeps it on
track.

### 1. Initialize (you do this, once per project)

In a command-line shell in your project directory, run:

```bash
designlens init
```

This will create a `specs/` folder, a `.designlens.json` config file, and will
update (or create) your `AGENTS.md` (or `CLAUDE.md`) so agents know to read the
specs on session start. You'll also be asked to specify which agent you'll be
using, and `init` will populate the appropriate directory with agent-specific
command files. For agents other than Claude Code and OpenCode, `init` will
create proforma command files in `.opencode/command/`. Copy these to your
agent's commands directory (e.g. `.github/agents/`, `.cursor/rules/`) and
modify them to match your agent's format if needed. To request native support
for additional agents, please [open an
issue](https://github.com/ropensci-review-tools/designlens/issues). Note that
metadata aggregation is currently only possible for opencode and Claude Code.

For established projects, `init` will also generate a `000-design-history` stub
from your git log as a starting point. You should then run
`/designlens.retrospective` as the _first_ stage to generate the design history
until that point. This is used as the basis to inform further evolution of
design history.

From that point on, all commands are always run in your agent-based CLI.

### 2. Start a stage

Run `/designlens.new-stage` in your agent. It will ask questions until it has
enough detail to write a concrete plan, then call `designlens new-stage` to create
the stage directory and populate `specs/001-stage-name/plan.md`. Once the plan is
written, it shows you the result and asks you to review it.

### 3. Break down tasks

Run `/designlens.make-tasks`. The agent reads `plan.md` and produces `tasks.md`:
a list of concrete, checkboxed implementation steps, each prefixed with a
stage-scoped ID (`T001-1`, `T001-2`, …).

### 4. Implement

Run `/designlens.implement`. The agent works through `tasks.md` sequentially,
checking off each task as it is completed.

### 5. Wrap up the stage

When all tasks are checked off, run `/designlens.retrospective`. The agent
generates `design-decisions.md`: a concise, anonymized summary of what was
decided and why, cross-referencing prior stages to show how the design evolves.
It also writes `.metadata.json` with token usage, lines written, and files
changed for the stage — accumulated across all sessions, so the record stays
complete even when a stage spans multiple working sessions.

### 6. Check where you are at any point

Run `/designlens.status` to report the current stage, task completion, and the
one next action to take. Start every session by asking your agent to run it.
In a shell, you can also run
```bash
designlens status
```

To directly see the current stage, and any outstanding tasks.

### 7. Repeat

Once a stage is complete, run `/designlens.new-stage` again.

## Help and maintenance

To list commands and capabilities of {designlens}, run,
```bash
designlens help
```
in a command shell, or `/designlens.help` in an agent CLI environment. You can
also update or uninstall the tool with:

```bash
designlens update     # update to the latest version
designlens uninstall  # remove the tool (your specs/ folders are untouched)
```

## Documentation

See
[`docs/conventions.md`](https://github.com/ropensci-review-tools/designlens/blob/main/docs/conventions.md)
for the full workflow specification, file format templates, and agent
instructions.

## Prior art

The forward design workflow borrows heavily from
[spec-kit](https://github.com/github/spec-kit), and is in many ways a
streamlined version of similar ideas. {designlens} extends that model with the
backward-facing retrospective step.

## License

MIT. See [LICENSE](LICENSE) for details.
