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
5. When the user is satisfied, tell them to run `/make-tasks` (or `designlens make-tasks` if not using slash commands).
