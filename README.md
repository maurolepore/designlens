# designlens

A design history tool for open source projects. Captures the reasoning behind
code as it's written—so future contributors understand not just *what* the code
does, but *why* it evolved the way it did.

## What it does

Each feature or change is developed as a numbered *stage*. A stage produces three
artifacts, committed to your repo under `specs/`:

- **plan.md** — the design vision: what you're building and why
- **tasks.md** — the execution breakdown: concrete, checkboxed steps
- **design-decisions.md** — the reasoning record: what was decided, what was traded off, how it connects to prior stages

Over time, `specs/` becomes an archaeological record of your project's evolution,
readable by contributors who weren't there when the decisions were made.

## Installation

### Linux / macOS

```bash
curl -fsSL https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.sh | bash
```

### Windows

```powershell
irm https://raw.githubusercontent.com/ropensci-review-tools/designlens/main/install.ps1 | iex
```

## How to use designlens

designlens is built for agent CLI environments like Claude Code. Most commands
are instructions you give your agent, not things you type in a shell yourself.
When an agent runs a designlens command, it receives instructions telling it
exactly what to do next—read this file, populate these fields, generate that
document. The agent does the work; designlens keeps it on track.

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

### 2. Start a stage (ask your agent)

Tell your agent:

> Run `designlens new-stage "what you want to build"`

The agent creates `specs/001-stage-name/plan.md` with a structured template, then
fills it out—goals, approach, open questions—based on your description and the
project context. Once the plan is written, it shows you the result and asks you
to review it.

### 3. Break down tasks (ask your agent)

Tell your agent:

> Run `designlens make-tasks`

The agent reads `plan.md` and produces `tasks.md`: a list of concrete, checkboxed
implementation steps, each prefixed with a stage-scoped ID (`T001-1`, `T001-2`, …).

### 4. Implement

Work through the tasks with your agent. Each task is checked off as it's completed.
designlens doesn't prescribe how this works—it just tracks progress via the
checkboxes in `tasks.md`.

### 5. Wrap up the stage (ask your agent)

When all tasks are checked off:

> Run `designlens retrospective`

The agent generates `design-decisions.md`: a concise, anonymized summary of what
was decided and why, cross-referencing prior stages to show how the design
evolves. This is the document future contributors will read.

### 6. Check where you are at any point

```bash
designlens status
```

This works in a shell or as an agent instruction. It reports the current stage,
task completion, and the one next action to take. Start every session by asking
your agent to run it.

### 7. Repeat

Once a stage is complete, ask your agent to run `designlens new-stage` again.

## Maintenance

```bash
designlens update     # update to the latest version
designlens uninstall  # remove the tool (your specs/ folders are untouched)
```

## Documentation

See `docs/conventions.md` for the full workflow specification, file format
templates, and agent instructions.

## License

MIT. See [LICENSE](LICENSE) for details.
