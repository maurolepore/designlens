# File Formats

Templates and style guides for the four key files in each design stage.

## plan.md

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

## tasks.md

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

## design-decisions.md

**Purpose:** Document design decisions made during this stage, integrated with the project's overall design evolution.

Each `design-decisions.md` focuses on **what's new in this stage** while cross-referencing previous decisions to show how the design builds over time. This keeps documents concise while preserving the complete architectural narrative.

**Template:**

```markdown
# Design Decisions: [Stage Title]

## Summary
[1-2 sentences: what was accomplished and the key decisions made in THIS stage]

## New Design Decisions

### Decision 1: [What was decided in this stage]
**Chosen:** [The option selected]
**Rationale:** [Why this was chosen over alternatives]
**Tradeoffs:** [What was given up]
**Relates to:** [Brief cross-reference if building on prior work]

### Decision 2: [What was decided]
**Chosen:** [The option selected]
...

## Integration with Prior Work
[How this stage's decisions connect to and build on previous stages.
Use cross-references to earlier design-decisions.md files to avoid repetition.
Example: "Building on the auth system from 001-auth (see that stage's decisions on token storage)"]

## Issues Resolved
- [Issue from plan.md and how it was resolved]

## Deferred Items
[Things discussed but deferred to later stages]

## Process Notes
[How design evolved or changed direction; blockers encountered]
```

**Style:**
- Concise (typically 200–400 words for later stages, 300–500 for early stages)
- Focus on **what's new**, not what was already decided
- Use cross-references freely: "See NNN-stage/design-decisions.md for..." is preferred over repeating prior reasoning
- Focus on the *why*, not the *what* (the what is in the code already)
- Each stage's doc should be readable on its own, but complete history is reconstructed by reading from 000-design-history forward

**Cross-referencing guidance:**
- When a decision builds on previous work, reference the earlier stage explicitly
- Include the stage folder name and section where the prior decision was made
- Example: "See 001-core-architecture/design-decisions.md#New%20Design%20Decisions for the foundational decision on module structure"
- This approach keeps each doc focused while preserving the narrative arc

## .transcript.md

**Purpose:** Record the raw session conversation(s) with semi-anonymized speaker attribution.

**Format:**

```markdown
## Turn 1
**[git-user-name]:** [The participant's message, with personal expressions removed]

## Turn 2
**assistant:** [The assistant's message]

## Turn 3
**[git-user-name]:** [The participant's message, with personal expressions removed]

## Turn 4
**assistant:** [The assistant's message]
```

**Style:**
- Simple turn-by-turn format
- Speaker labels: `**[git-user-name]:**` (from `git config user.name`) and `**assistant:**`
- Message content: anonymized — remove personal expressions, anecdotes, or identifying information
- Full message text (cleaned of personal information and expressions), not paraphrased
- One transcript per `.transcript.md` file; if multiple sessions, use `.transcript-1.md`, `.transcript-2.md`, etc.
- Multiple participants: each uses their own `git config user.name` as the label

---

See [transcript-format.md](transcript-format.md) for detailed guidance on creating anonymized transcript summaries.
