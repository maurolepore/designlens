# designlens Workflow

The designlens workflow has 5 phases per stage, from initialization through retrospective and into the next cycle.

## Phase 1: Initialize the stage

```bash
designlens init
```

Run once per project. Initializes git (if needed), creates `/specs`, lockfile, and AGENTS.md/CLAUDE.md pointer. Detects or prompts for your agent (Claude Code, OpenCode, or other) and installs the workflow command files into the agent's commands directory. Commit behavior is configured here and stored in `.designlens.json`.

For agents other than Claude Code and OpenCode, select `other` at the prompt. Proforma command files will be created in `.opencode/command/` — copy them to your agent's commands directory and modify as needed. To request native support for additional agents, open an issue at https://github.com/ropensci-review-tools/designlens/issues.

## Phase 2: Plan the stage

Agent command: `/designlens.new-stage` (installed by `init`)

1. **Agent starts** in the repo
   - Automatically reads AGENTS.md/CLAUDE.md (Claude Code, etc.)
   - Learns that specs exist and reads conventions.md
   - Runs `designlens status` to determine current state

2. **Developer invokes `/designlens.new-stage`**
   - Agent asks clarifying questions
   - Documents constraints
   - Proposes approaches
   - Iterates on the design

3. **Agent calls** `designlens new-stage "<description>" "<slug>"` to create the stage directory and `plan.md` template, then populates every section.

4. **Developer reviews** `plan.md` and confirms.

**Output:** `/specs/NNN-stage-name/plan.md`

## Phase 3: Convert plan into tasks

Agent command: `/designlens.make-tasks` (installed by `init`)

1. **Developer invokes `/designlens.make-tasks`**
2. **Agent reads** plan.md and writes tasks.md
   - Breaks the plan into actionable tasks
   - Each task has a checkbox (unchecked) and a unique ID (e.g. `T001-1`, `T001-2`)
   - Clear acceptance criteria per task
3. **Developer reviews** tasks.md before implementation begins

**Output:** `/specs/NNN-stage-name/tasks.md`

## Phase 4: Implement tasks

Agent command: `/designlens.implement` (installed by `init`)

1. **Developer invokes `/designlens.implement`**
2. **Agent executes** the tasks
   - Runs code, writes tests, creates docs
   - Checks off completed tasks in tasks.md

3. **Developer provides** feedback
   - Pushes back on design choices
   - Suggests improvements
   - Agent adapts

4. **Agent ensures** all tasks are complete
   - When all tasks marked done, moves to Phase 5

**Output:** Code changes, committed to the stage branch

## Phase 5: Create retrospective

Agent command: `/designlens.retrospective` (installed by `init`)

1. **Developer invokes `/designlens.retrospective`**
2. **Agent creates the session transcript** (`.transcript.md`)
   - Semi-anonymized summary of what was discussed and decided
   - Speaker attribution uses `git config user.name`; content is depersonalized

3. **Agent writes the stage design-decisions.md**
   - Reads plan.md, tasks.md, and the session transcript
   - Reviews design-decisions.md from all previous stages for context
   - Documents **what's new in this stage** (200–400 words typically)
   - Cross-references prior decisions to show integration

4. **Agent updates the root design summary** (`specs/design-decisions.md`)
   - Reads all stage design-decisions.md files, in order
   - Rewrites `specs/design-decisions.md` as a coherent project-level narrative

**Output:** `/specs/NNN-stage-name/design-decisions.md` and `/specs/design-decisions.md`

---

The stage is complete. Run `/designlens.new-stage` to begin the next cycle. The tool will warn if the previous stage lacks design-decisions.md and offer to run `/designlens.retrospective`.

---

See [conventions.md](conventions.md) for the big picture, [file-formats.md](file-formats.md) for templates, and [agent-instructions.md](agent-instructions.md) for how agents should behave at each phase.
