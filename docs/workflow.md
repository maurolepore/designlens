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

1. **Agent creates the session transcript** (`.transcript.md`)
   - Semi-anonymized summary of what was discussed and decided
   - Speaker attribution uses `git config user.name`; content is depersonalized

2. **Agent writes the stage design-decisions.md**
   - Reads plan.md, tasks.md, and the session transcript
   - Reviews design-decisions.md from all previous stages for context
   - Documents **what's new in this stage** (200–400 words typically)
   - Cross-references prior decisions to show integration
   - Clear sections: Summary, New Design Decisions, Integration with Prior Work, Deferred Items

3. **Agent updates the root design summary** (`specs/design-decisions.md`)
   - Reads all stage design-decisions.md files, in order
   - Rewrites `specs/design-decisions.md` as a coherent project-level narrative
   - Describes the **current architecture** (derived from the latest plan.md)
   - Traces the key decisions that led to the present form across all stages
   - Highlights important roads not taken and why they were rejected
   - No size limit; grows with the project but prunes superseded detail

**Output:** `/specs/NNN-stage-name/design-decisions.md` and `/specs/design-decisions.md`

---

The stage is complete. Run `designlens new-stage "next-stage-name"` to begin the next cycle. The tool will warn if the previous stage lacks design-decisions.md and offer to run retrospective.

---

See [conventions.md](conventions.md) for the big picture, [file-formats.md](file-formats.md) for templates, and [agent-instructions.md](agent-instructions.md) for how agents should behave at each phase.
