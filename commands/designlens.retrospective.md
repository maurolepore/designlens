---
description: Generate transcript and design decisions for the current stage
---

Find the latest (highest-numbered) stage directory under `specs/`. Verify that `plan.md` and `tasks.md` exist in it. If either is missing, stop and tell the user what is needed.

If `design-decisions.md` already exists in that directory, ask before overwriting.

Read `.designlens.json` to get `auto_commit` and run `git config user.name` to get the git user.

---

## STEP 1 OF 3: Session transcript

Create a semi-anonymized summary transcript of this design session and save it to `<stage_dir>/.transcript.md`.

### Format

```markdown
# Session Transcript: [Stage Title]

## Session Overview
[1-2 sentences summarizing what was discussed and decided]

## Design Decisions Made

### Decision 1: [What was decided]
**Chosen:** [The option selected]
**Rationale:** [Why this was chosen over alternatives]
**Tradeoffs:** [What was sacrificed or deferred]
**Proposed by:** [git-user | agent | joint]

### Decision 2: [What was decided]
[Same structure]

## Tradeoffs Considered
- [Option A vs Option B]: [Why the chosen option won]

## Open Questions
- [Any unresolved questions or deferred items]
```

### Anonymization requirements (non-negotiable)
- Speaker labels: use `git config user.name`, not "human", "user", or real names
- No personal expressions, anecdotes, or preferences in first person
- No email addresses or identifying information
- No user counts, revenue, or business-specific details
- Focus on technical reasoning and decisions, not speakers

### Role attribution (required for every decision)
- Every decision MUST have a "Proposed by" field
- Use `git config user.name` for the human participant
- Use `agent` for the AI assistant
- Use `joint` when both contributed equally

**Length:** 150–400 words. Concise and scannable.

---

## STEP 2 OF 3: Generate `design-decisions.md`

Read `plan.md`, `tasks.md`, and `.transcript.md` from the current stage. Also read `design-decisions.md` from all previous stages (in order) for context.

Generate `<stage_dir>/design-decisions.md` documenting what is **new in this stage**:

```markdown
# Design Decisions: [Stage Title]

## Summary
[1-2 sentences of what was accomplished and the key decisions made]

## New Design Decisions

### Decision 1: [What was decided in THIS stage]
**Chosen:** [The option selected]
**Rationale:** [Why; focus on technical/business reasons]
**Tradeoffs:** [What was sacrificed]
**Proposed by:** [git-user | agent | joint]  (omit if not relevant)
**Relates to:** [Brief cross-ref if building on prior work]

### Decision 2: [What was decided]
[Same structure]

## Integration with Prior Work
[How this stage's decisions connect to and build on previous stages.]

## Issues Resolved
- [Issue from plan.md: how it was resolved]

## Deferred Items
[Things discussed but deferred to later stages]

## Process Notes
- [How design evolved or changed direction]
- [Blockers encountered]
```

Anonymization: no personal names, email addresses, or identifying information. Use passive voice or role-based language. 200–400 words; cross-reference prior stages rather than repeating them.

---

## STEP 3 OF 3: Update `specs/design-decisions.md`

Read the `design-decisions.md` from every stage in order (including the one just written). Also read the current stage's `plan.md` to understand the project's current form.

Write or update `specs/design-decisions.md` as a coherent project-level narrative:

```markdown
# Design Decisions: [Project Name]

## Current Architecture
[Description of the present form, synthesised from the latest plan.md]

## Key Decisions

### [Decision title]
**Outcome:** [What was decided and remains true today]
**Rationale:** [Why, synthesised across the stages that shaped it]
**Roads not taken:** [Alternatives considered and rejected, with reasons]
**Stages:** [Which stage(s) made or refined this decision]

## Architectural Evolution
[Narrative of how the design evolved — what changed across stages and why]

## Important Roads Not Taken
[Significant alternatives rejected at any stage, grouped by theme, with rationale]
```

No personal names, email addresses, or identifying information throughout.

---

## After completing all three steps

```bash
git add <stage_dir>/ specs/design-decisions.md
```

- If `auto_commit` is `true`: commit with `git commit -m "<NNN>: Add design decisions"`
- If `auto_commit` is `false`: do NOT commit — stage only, leave the commit to the user.

Tell the user to run `/designlens.new-stage` when ready to start the next stage.
