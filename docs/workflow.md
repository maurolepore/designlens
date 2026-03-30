# designlens Workflow

The designlens workflow has 5 phases per stage, from initialization through retrospective and into the next cycle.

## Phase 1: Initialize the stage

```bash
designlens init
```

Run once per project. Initializes git (if needed), creates `/specs`, lockfile, and AGENTS.md/CLAUDE.md pointer. Commit behavior is configured here and stored in `.designlens.json`.

## Phase 2: Plan the stage

```bash
designlens new-stage "stage description"
```

1. **Agent starts** in the repo
   - Automatically reads AGENTS.md/CLAUDE.md (Claude Code, etc.)
   - Learns that specs exist and reads conventions.md
   - Runs `designlens status` to determine current state

2. **Developer describes** the work to the agent
   - "I want to add data validation to the pipeline"
   - "Let's refactor the error handling system"
   - etc.

3. **Agent explores** through dialogue
   - Asks clarifying questions
   - Documents constraints
   - Proposes approaches
   - Iterates on the design

4. **Agent writes** plan.md
   - Captures the agreed-upon design
   - Documents the reasoning
   - Lists open questions or deferred decisions

**Output:** `/specs/NNN-stage-name/plan.md`

## Phase 3: Convert plan into tasks

```bash
designlens make-tasks
```

1. **Developer reviews** plan.md and triggers task generation
2. **Agent reads** plan.md and writes tasks.md
   - Breaks the plan into actionable tasks
   - Each task has a checkbox (unchecked) and a unique ID (e.g. `T001-1`, `T001-2`)
   - Clear acceptance criteria per task
3. **Developer reviews** tasks.md before implementation begins

**Output:** `/specs/NNN-stage-name/tasks.md`

## Phase 4: Implement tasks

```bash
designlens implement
```

1. **Agent executes** the tasks
   - Runs code, writes tests, creates docs
   - Checks off completed tasks in tasks.md
   - Commits progress to git

2. **Developer provides** feedback
   - Pushes back on design choices
   - Suggests improvements
   - Agent adapts

3. **Agent ensures** all tasks are complete
   - When all tasks marked done, moves to Phase 5

**Output:** Code changes, committed to the stage branch

## Phase 5: Create retrospective

```bash
designlens retrospective
```

1. **Agent analyzes** the stage and project history
   - Reads plan.md, tasks.md, and the session transcript (if available)
   - Reviews design-decisions.md from all previous stages (000-design-history, 001, 002, etc.)
   - Summarizes key design decisions made **in this stage**
   - Shows how this stage builds on or extends prior architectural decisions
   - Identifies tradeoffs specific to this stage

2. **Agent writes** design-decisions.md
   - Documents **what's new in this stage** (200–400 words typically)
   - Cross-references prior decisions to show integration (e.g., "See 001-auth for the foundational decision on token storage")
   - Clear sections: Summary, New Design Decisions, Integration with Prior Work, Deferred Items
   - Markdown format

**Output:** `/specs/NNN-stage-name/design-decisions.md`

---

The stage is complete. Run `designlens new-stage "next-stage-name"` to begin the next cycle. The tool will warn if the previous stage lacks design-decisions.md and offer to run retrospective.

---

See [conventions.md](conventions.md) for the big picture, [file-formats.md](file-formats.md) for templates, and [agent-instructions.md](agent-instructions.md) for how agents should behave at each phase.
