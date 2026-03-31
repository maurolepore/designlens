---
description: "1. Gather requirements and create a new design stage"
---

**Before doing anything else**, check whether `specs/000-design-history/` is the only subdirectory in `specs/` (i.e. no numbered stages exist yet). If other stage directories are present, skip this check entirely and proceed to the new-stage flow below.

If it is the only subdirectory, check whether its `design-decisions.md` contains a `<!-- PENDING` marker:

```bash
grep -l '<!-- PENDING' specs/000-design-history/design-decisions.md 2>/dev/null
```

If the file is found (i.e. the design history has not yet been generated from the git history), stop and tell the user clearly:

> **The project's design history has not been captured yet.**
> `specs/000-design-history/design-decisions.md` contains a pending generation task that analyses the git history and documents the project's architectural evolution. This should be completed before starting a new stage — without it, future design decisions will lack the context of how the project reached its current state.
>
> To complete it now, read `specs/000-design-history/design-decisions.md` and follow the instructions inside it.

Then ask: **"Complete the design history now before proceeding? (strongly recommended)"**

- If yes: read `specs/000-design-history/design-decisions.md`, follow the instructions inside it to generate the history from the git log, remove the `<!-- PENDING` block, and `git add` the file. Then continue with the new-stage flow below.
- If no: ask a second time — **"Are you sure? Skipping means future design decisions will lack historical context. Skip anyway? (y/n)"**
  - If yes: proceed with the new-stage flow below, but note to the user that they can complete the history at any time by reading `specs/000-design-history/design-decisions.md`.
  - If no: stop and wait for the user to instruct you.

---

Ask the user what they want to build in this stage. Keep asking clarifying questions until you have enough detail to write a concrete, actionable plan — covering goals, constraints, proposed approach, and open questions. Do not proceed until answers are specific enough to fill every section of plan.md with real content.

Once you have sufficient detail:

1. Derive a short verb-noun slug from the description (e.g. `add-auth`, `refactor-parser`). Do not ask the user for this.
2. Run: `designlens new-stage "<full description>" "<slug>"`
3. Read the generated `specs/NNN-<slug>/plan.md` and replace every placeholder section with real content drawn from the design discussion:
   - **Context** — relevant prior decisions and constraints from previous stage design-decisions.md files (if any exist in `specs/`)
   - **Design Goals** — concrete goals, not generic bullets
   - **Proposed Approach** — the high-level design decisions agreed in the conversation
   - **Open Questions** — anything unresolved or deferred
   Do not leave any field at its template default. If a section cannot be filled without more input, ask the user before proceeding.
4. Show the user the completed `plan.md` and ask them to review it.
5. When the user is satisfied, tell them to run `/designlens.make-tasks`.
