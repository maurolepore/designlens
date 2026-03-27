# designlog Workflow

The designlog workflow has 6 phases per stage, from initialization through retrospective and into the next cycle.

## Phase 1: Initialize (Terminal, once per project)

```bash
git init  # if needed
designlog init
```

This creates `/specs`, lockfile, and AGENTS.md/CLAUDE.md pointer.

## Phase 2: Plan (Agent Session)

1. **Agent starts** in the repo
   - Automatically reads AGENTS.md/CLAUDE.md (Claude Code, etc.)
   - Learns that specs exist and reads conventions.md
   - Runs `designlog status` to determine current state

2. **Developer describes** the work to the agent
   - "I want to build an authentication system"
   - "Let's refactor the data pipeline"
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

5. **Agent writes** tasks.md
   - Breaks the plan into actionable tasks
   - Each task has a checkbox (unchecked)
   - Clear acceptance criteria

**Output:** `/specs/NNN-stage-name/plan.md` and `tasks.md`

## Phase 3: Implement (Agent Session, continues)

1. **Agent executes** the tasks
   - Runs code, writes tests, creates docs
   - Checks off completed tasks in tasks.md
   - Commits progress to git

2. **Developer provides** feedback
   - Pushes back on design choices
   - Suggests improvements
   - Agent adapts

3. **Agent ensures** all tasks are complete
   - When all tasks marked done, moves to Phase 4

**Output:** Code changes, committed to the stage branch

## Phase 4: Retrospective (Agent Session)

When all tasks are complete:

1. **Agent or developer** runs `designlog retrospective`
   - Tool outputs a structured prompt
   - Developer/agent pastes it into the coding agent

2. **Agent analyzes** the stage and project history
   - Reads plan.md, tasks.md, and the session transcript (if available)
   - Reviews design-decisions.md from all previous stages (000-design-history, 001, 002, etc.)
   - Summarizes key design decisions made **in this stage**
   - Shows how this stage builds on or extends prior architectural decisions
   - Identifies tradeoffs specific to this stage

3. **Agent writes** design-decisions.md
   - Documents **what's new in this stage** (200–400 words typically)
   - Cross-references prior decisions to show integration (e.g., "See 001-auth for the foundational decision on token storage")
   - Clear sections: Summary, New Design Decisions, Integration with Prior Work, Deferred Items
   - Markdown format

**Output:** `/specs/NNN-stage-name/design-decisions.md`

## Phase 5: Commit

```bash
git add specs/NNN-stage-name/
git commit -m "NNN-stage-name: Design decisions and implementation"
```

The stage is complete. All three files are in git.

## Phase 6: Next Stage

Run `designlog new-stage "next-stage-name"` to begin the cycle again.

The tool will warn if the previous stage lacks design-decisions.md and offer to run retrospective.

---

See [conventions.md](conventions.md) for the big picture, [file-formats.md](file-formats.md) for templates, and [agent-instructions.md](agent-instructions.md) for how agents should behave at each phase.
