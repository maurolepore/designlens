---
description: "1. Gather requirements and create a new design stage"
---

## STEP 1 — Check for pending design history

Check whether `specs/000-design-history/` is the only subdirectory in `specs/` (i.e. no numbered stages exist yet). If other stage directories are present, skip this step entirely and jump to **STEP 2**.

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

- If yes: read `specs/000-design-history/design-decisions.md`, follow the instructions inside it to generate the history from the git log, remove the `<!-- PENDING` block, and `git add` the file. Then continue with **STEP 2**.
- If no: ask a second time — **"Are you sure? Skipping means future design decisions will lack historical context. Skip anyway? (y/n)"**
  - If yes: continue with **STEP 2**, but note to the user that they can complete the history at any time by reading `specs/000-design-history/design-decisions.md`.
  - If no: stop and wait for the user to instruct you.

---

## STEP 2 — Confirm working directory (first session after init only)

Source the emptiness detection library by sourcing the output of `designlens lib is-empty`:
```bash
eval "$(designlens lib is-empty)"
```

Check whether the current directory contains only the files and folders created by `designlens init` — that is, its contents are a subset of: `.designlens.json`, `AGENTS.md`, `specs/`, `.git/`, and one agent-specific config folder (e.g. `.claude/`). If there is anything else present, skip this step and jump to **STEP 3**.

If the emptiness detection function exists, call it to check for real content:
- If `is_project_empty` returns non-zero (project has real content), skip this step and jump to **STEP 3**.
- If it returns zero (truly empty project), ask the location question.

Alternatively, if the function is not available, manually check whether the current directory contains only init artifacts. If there is anything else present, the project already has real content here, so skip this step and jump to **STEP 3**.

If the directory contains only init artifacts (or the function confirms it's empty), ask:

> **Should this be built within the current directory, or inside a subdirectory?**
> The current directory is recommended — designlens is designed to be embedded directly in a project's main working directory.

Accept their answer before proceeding. If they choose a subdirectory, ask for its name and note it in the plan.

---

## STEP 3 — Gather requirements

Ask the user what they want to build in this stage. Keep asking clarifying questions until you have enough detail to write a concrete, actionable plan — covering goals, constraints, proposed approach, and open questions. Do not proceed until answers are specific enough to fill every section of plan.md with real content.

---

## STEP 4 — Create and populate the stage plan

Once you have sufficient detail:

1. Derive a short verb-noun slug from the description (e.g. `add-auth`, `refactor-parser`). Do not ask the user for this.
2. Run: `designlens new-stage "<full description>" "<slug>"`
3. Read the generated `specs/NNN-<slug>/plan.md` and replace every placeholder section with real content drawn from the design discussion:
   - **YAML front-matter** — fill `created` with the current UTC timestamp in ISO 8601 format (e.g. `2026-03-31T14:05:00Z`) and `agent` with your model identifier (e.g. `claude-sonnet-4-6`)
   - **Context** — relevant prior decisions and constraints from previous stage design-decisions.md files (if any exist in `specs/`)
   - **Design Goals** — concrete goals, not generic bullets
   - **Proposed Approach** — the high-level design decisions agreed in the conversation
   - **Open Questions** — anything unresolved or deferred
   Do not leave any field at its template default. If a section cannot be filled without more input, ask the user before proceeding.
4. Show the user the completed `plan.md` and ask them to review it.
5. When the user is satisfied, tell them to run `/designlens.make-tasks`.
