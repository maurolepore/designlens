# speclog Conventions and Workflow

This document defines the complete speclog workflow, file formats, and instructions for agents.

## Table of Contents

1. [Overview](#overview)
2. [Folder Structure](#folder-structure)
3. [Workflow](#workflow)
4. [File Formats](#file-formats)
5. [Agent Instructions](#agent-instructions)
6. [Transcript Format](#transcript-format)

---

## Overview

speclog is a design history tool for open source projects. It captures the progression from rough ideas → formalized plans → task breakdown → implementation → retrospective decisions.

The core value: future contributors can understand *why* the code is the way it is, not just *what* it does.

### Key Principle

Every design stage produces three artifacts:
- **plan.md** — The design vision (what and why)
- **tasks.md** — The execution breakdown (how)
- **decisions.md** — The reasoning summary (why we chose this path)

Combined with session transcripts, these form a complete archaeological record of the project's evolution.

---

## Folder Structure

```
your-project/
  specs/
    README.md
    001-initial-concept/
      plan.md
      tasks.md
      decisions.md
      .transcript.md
    002-auth-system/
      plan.md
      tasks.md
      decisions.md
      .transcript.md
    003-...
  .specmeta.json
  AGENTS.md (or CLAUDE.md)
  ...
```

### Key Points

- **specs/** is the public design record, committed to git
- Each stage folder is numbered with a 3-digit prefix (001, 002, etc.)
- Within each stage: everything is self-contained
- **.specmeta.json** is a tiny lockfile with tool metadata (optional to commit, but recommended)
- **AGENTS.md/CLAUDE.md** points agents to the specs on session start
- Transcripts are dot-prefixed (`.transcript.md`) to signal they're raw artifacts

### Handling Parallel Development

If two branches diverge at the same stage (e.g., both have `001-*`), that's fine:
- Git tracks which branch merged
- The folder names can have suffixes: `001-feature-a`, `001-feature-b`
- Duplicate numeric prefixes signal parallel exploration, which is meaningful design history

When one branch merges and another diverges, the history naturally captures the divergence and resolution.

---

## Workflow

### Phase 1: Initialize (Terminal, once per project)

```bash
git init  # if needed
speclog init
```

This creates `/specs`, lockfile, and AGENTS.md/CLAUDE.md pointer.

### Phase 2: Plan (Agent Session)

1. **Agent starts** in the repo
   - Automatically reads AGENTS.md/CLAUDE.md (Claude Code, etc.)
   - Learns that specs exist and reads conventions.md
   - Runs `speclog status` to determine current state

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

### Phase 3: Implement (Agent Session, continues)

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

### Phase 4: Retrospective (Agent Session)

When all tasks are complete:

1. **Agent or developer** runs `speclog retrospective`
   - Tool outputs a structured prompt
   - Developer/agent pastes it into the coding agent

2. **Agent analyzes** the stage
   - Reads plan.md, tasks.md, and the session transcript (if available)
   - Summarizes key design decisions made
   - Attributes them: human vs AI, who proposed, who decided
   - Documents important tradeoffs

3. **Agent writes** decisions.md
   - Concise summary (under 500 words typically)
   - Clear sections: Decisions, Tradeoffs, Attribution, Deferred Items
   - Markdown format

**Output:** `/specs/NNN-stage-name/decisions.md`

### Phase 5: Commit

```bash
git add specs/NNN-stage-name/
git commit -m "NNN-stage-name: Design decisions and implementation"
```

The stage is complete. All three files are in git.

### Phase 6: Next Stage

Run `speclog new-stage "next-stage-name"` to begin the cycle again.

The tool will warn if the previous stage lacks decisions.md and offer to run retrospective.

---

## File Formats

### plan.md

**Purpose:** Define what you're building and why.

**Template:**

```markdown
# Plan: [Stage Title]

## Overview
[1-2 sentence summary of what this stage accomplishes]

## Context
[Previous decisions and how this stage builds on them]

## Design Goals
- [Goal 1]
- [Goal 2]
- [Goal 3]

## Proposed Approach
[High-level design: architecture, key components, technology choices]

[Subsection for major decisions, e.g.]

### Authentication
[Design choice for auth: OAuth, JWT, session cookies, etc. and why]

## Open Questions
- [Question 1: unresolved, will be explored during implementation]
- [Question 2: deferred to next stage]

## Constraints and Assumptions
[Budget, timeline, compatibility requirements, etc.]
```

**Style:**
- Clear, readable, assume audience includes contributors unfamiliar with the project
- Be specific about choices, not vague
- Explain *why* choices were made, not just *what* was chosen
- Mark uncertain items as "Open Questions" — don't overstate confidence

### tasks.md

**Purpose:** Break plan.md into concrete, executable steps.

**Template:**

```markdown
# Tasks: [Stage Title]

## Overview
[Brief description of how the work is structured]

## Task Checklist

- [ ] Task 1: [Specific outcome]
- [ ] Task 2: [Specific outcome]
- [ ] Task 3: [Specific outcome]

### Task 1: [Specific outcome]

**Acceptance Criteria:**
- Criterion A
- Criterion B
- Criterion C

**Implementation Notes:**
- Note 1
- Note 2

## Notes
[Any additional context, dependencies, or gotchas]
```

**Style:**
- Each task should be completable in a single session (or clearly marked as multi-session)
- Tasks should be roughly equal in scope
- Acceptance criteria are testable
- Checkbox format: `- [ ]` (unchecked), `- [x]` (checked)

### decisions.md

**Purpose:** Document design decisions made during this stage.

**Template:**

```markdown
# Design Decisions: [Stage Title]

## Summary
[1-2 sentences: what was accomplished, what was decided]

## Key Decisions

### Decision 1: [What was decided]
**Chosen:** [The option selected]
**Rationale:** [Why this was chosen over alternatives]
**Proposed by:** [Human/AI, and who]
**Tradeoffs:** [What was given up]

### Decision 2: [What was decided]
**Chosen:** [The option selected]
...

## Important Tradeoffs
[If multiple decisions involved significant tradeoffs, summarize them here]

## Attribution
- **Human inputs:** [What the human contributed — constraints, feedback, direction]
- **AI role:** [What the AI contributed — proposals, analysis, implementation]

## Deferred Decisions
[Items that came up but were explicitly deferred to a later stage]

## Open Questions
[Items that remain unresolved]
```

**Style:**
- Concise (typically 300–500 words)
- Attribution is honest: decisions aren't just "made" — they come from someone or some interaction
- Focus on the *why*, not the *what* (the what is in the code already)

### .transcript.md

**Purpose:** Record the raw session conversation(s).

**Format:**

```markdown
## Turn 1
**human:** [The human's message]

## Turn 2
**assistant:** [The assistant's message]

## Turn 3
**human:** [The human's message]

## Turn 4
**assistant:** [The assistant's message]
```

**Style:**
- Simple turn-by-turn format
- Labeled clearly with `**human:**` and `**assistant:**`
- Full message text, not paraphrased
- One transcript per `.transcript.md` file; if multiple sessions, use `.transcript-1.md`, `.transcript-2.md`, etc.
- Multiple participants: use git branch info and commit metadata to disambiguate; within a single session, the "human" label refers to whoever initiated that session

---

## Agent Instructions

**If you're an agent starting a session in a project with speclog:**

### At Session Start

1. **Check for spec setup:**
   ```bash
   speclog status
   ```

2. **Read the current state:**
   - If no stages exist, work with the human to start the first stage
   - If a stage has no plan.md, help the human develop the design
   - If a stage has no tasks.md, break the plan into tasks
   - If tasks are incomplete, help execute them
   - If all tasks are done but no decisions.md exists, run the retrospective

### During the Session

1. **Follow speclog conventions**
   - When writing plan.md, use the template above
   - When writing tasks.md, use clear checkboxes and acceptance criteria
   - Encourage the human to record important design discussions

2. **Facilitate decisions**
   - When the human proposes an idea, document it clearly in plan.md
   - When you propose an approach, explain the rationale
   - If you're unsure, mark it as an "Open Question"
   - When a decision is made, confirm it's clear in plan.md

3. **Track progress**
   - Maintain the task checklist in tasks.md
   - Check off tasks as they're completed
   - Ask for human approval before marking tasks done
   - Run `speclog status` periodically to show progress

4. **Record the conversation**
   - If the human asks, or if significant design decisions were made, save a normalized transcript to `.transcript.md`
   - Use the standard format (Turn N, human:/assistant: labels)

### When the Stage Is Complete

1. **Confirm all tasks are done:**
   - Run `speclog status` — it should say "Stage complete!"

2. **Generate decisions.md:**
   - Run `speclog retrospective`
   - Follow the prompt it provides
   - Write a concise summary of key decisions and tradeoffs
   - Be specific about attribution: what came from the human vs. the AI

3. **Guide the human to commit:**
   ```bash
   git add specs/NNN-stage-name/
   git commit -m "NNN-stage-name: Design decisions and implementation"
   ```

4. **Start the next stage:**
   - Ask the human what to work on next
   - Run `speclog new-stage "next-stage-name"`
   - Begin planning again

### Key Principles

- **Specs are for humans first:** Write them clearly, as if a contributor 6 months from now will read them
- **Attribute honestly:** Design decisions come from somewhere — acknowledge the source
- **Mark uncertainty:** Don't pretend to be certain when you're not; use "Open Questions"
- **Facilitate, don't control:** The human makes the design calls; your job is to explore, propose, and document

---

## Transcript Format Specification

**Why a standard?** Transcripts should be readable and parseable regardless of the tool that created them.

### Format

```
## Turn N
**human:** [Message text]

## Turn N+1
**assistant:** [Message text]
```

### Rules

1. **Turns are numbered** starting from 1
2. **Each speaker is labeled** with `**human:**` or `**assistant:**`
3. **Message text is the full, unparaphrased content**
4. **Newlines within a message** are preserved as-is
5. **Only two speaker roles** — use git metadata (branch, commit author) for disambiguation if multiple humans are involved
6. **File naming:**
   - First transcript: `.transcript.md`
   - Additional transcripts: `.transcript-1.md`, `.transcript-2.md`, etc.
   - Stored within the stage folder alongside plan.md and tasks.md

### Example

```markdown
## Turn 1
**human:** Let's design the authentication system. I want it to be secure but not overly complex for a small team.

## Turn 2
**assistant:** Good starting point. A few questions to narrow it down:
1. How many users are you expecting?
2. Do you need SSO or is basic login sufficient?
3. Any compliance requirements (GDPR, HIPAA, etc.)?

## Turn 3
**human:** Maybe 1000 users initially, scaling to 10k. No SSO needed yet. GDPR compliance is important since we have EU users.

## Turn 4
**assistant:** With that in mind, I'd suggest:
- JWT tokens for stateless auth
- Bcrypt for password hashing
- Refresh tokens for session management
- Minimal user data collection (just email, name)

This keeps it simple while meeting GDPR (we don't collect unnecessary data).

## Turn 5
**human:** JWT sounds good. But I'm concerned about token revocation — what if we need to immediately log someone out?

## Turn 6
**assistant:** Valid concern. We have options:
1. Accept short token lifetime (5–15 minutes) and log out at refresh
2. Keep a revocation list for immediate logout
3. Hybrid: short lifetime + optional revocation for urgent cases

Option 1 is simplest; Option 3 is safest. Given GDPR, I'd lean toward 3.

## Turn 7
**human:** Let's do Option 3. And we can add the revocation list as a task for Phase 2 if we don't need it immediately.
```

---

## FAQ

**Q: Should we commit the .specmeta.json lockfile?**
A: Yes, it's useful for future contributors to know what tool was used and where to find docs.

**Q: What if the human and AI disagree on a design?**
A: Document both perspectives in plan.md under a "Considered Alternatives" section. The human makes the final call, but recording the discussion is valuable history.

**Q: Can a stage skip tasks.md and go straight to code?**
A: Not recommended. tasks.md is the bridge between intention (plan.md) and action. If the plan is solid, tasks should be quick to write and invaluable for tracking progress.

**Q: What if a task is discovered mid-implementation?**
A: Add it to tasks.md and update the task count in the checklist. This is part of normal development.

**Q: How do we handle mistakes or design changes mid-stage?**
A: Update plan.md and tasks.md to reflect the change. Git will track the changes. Mention the decision in decisions.md at retrospective time.

**Q: Can multiple people work on one stage?**
A: Yes. Use git branches and merging as normal. The transcript will have multiple human turns; use git metadata to see who said what.

**Q: How long should a stage be?**
A: As long as it needs. Some stages might be a few hours; others might be weeks. If a stage is getting very long, consider breaking it into multiple stages.

---

## Tools and Integration

### Command Reference

```bash
speclog init                    # Initialize project (once)
speclog new-stage <name>        # Create new stage
speclog status                  # Show current state and next action
speclog retrospective           # Generate decisions.md
speclog transcript <file>       # Normalize a transcript
speclog update                  # Update to latest version
```

### IDE Integration

Most IDEs and coding agents (Claude Code, Cursor, etc.) can execute shell commands. Use that to call speclog commands during a session.

### Git Workflow

```bash
# Start a new stage
speclog new-stage "feature-name"
git checkout -b specs/feature-name

# Work on the stage
[edit plan.md, write code, check off tasks]
git add .
git commit -m "WIP: Feature implementation"

# Complete the stage
speclog retrospective
git add specs/feature-name/decisions.md
git commit -m "feature-name: Design decisions"

# Merge
git checkout main
git merge specs/feature-name
```

---

## Examples

See the project's `/specs` folder for real examples of plan.md, tasks.md, and decisions.md files generated through the tool.
