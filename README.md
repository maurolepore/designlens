# designlens

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

Each feature or change is developed as a numbered *stage*. A stage produces three
artifacts, committed to your repo under `specs/`:

- [**plan.md**](https://github.com/ropensci-review-tools/designlens/blob/main/docs/workflow.md#phase-2-plan-the-stage) — the design vision: what you're building and why
- [**tasks.md**](https://github.com/ropensci-review-tools/designlens/blob/main/docs/workflow.md#phase-3-convert-plan-into-tasks) — the execution breakdown: concrete, checkboxed steps
- [**design-decisions.md**](https://github.com/ropensci-review-tools/designlens/blob/main/docs/workflow.md#phase-5-create-retrospective) — the reasoning record: what was decided, what was traded off, how it connects to prior stages

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

For agents other than Claude Code and OpenCode, `init` will create proforma
command files in `.opencode/command/`. Copy these to your agent's commands
directory (e.g. `.github/agents/`, `.cursor/rules/`) and modify them to match
your agent's format if needed. To request native support for additional agents, please
[open an issue](https://github.com/ropensci-review-tools/designlens/issues).

The exception is setup: `init` is a one-time step you run yourself before handing
off to an agent.

### 1. Initialize (you do this, once per project)

In your project directory:

```bash
designlens init
```

This creates the `specs/` folder, a `.designlens.json` config file, and updates
your `AGENTS.md` (or `CLAUDE.md`) so agents know to read the specs on session
start. For established projects, it can generate a `000-design-history` stub from
your git log as a starting point.

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
These are the documents future contributors will read.

### 6. Check where you are at any point

```bash
designlens status
```

This works in a shell or as an agent instruction. It reports the current stage,
task completion, and the one next action to take. Start every session by asking
your agent to run it.

### 7. Repeat

Once a stage is complete, run `/designlens.new-stage` again.

## Maintenance

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
