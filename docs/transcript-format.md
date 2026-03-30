# Transcript Format Specification

How to create anonymized transcript summaries for design stages.

## Purpose

Document key design decisions, rationale, and reasoning from a stage session. Transcripts are *summaries*, not raw recordings — designed to be readable by future contributors and appropriately semi-anonymized.

**Why a standard?** Design decision summaries should be readable, maintainable, and focused on the *thinking process* and *decisions made*, not the people involved. Speaker attribution uses git metadata (user.name), but message content is cleaned of personal expressions and identifying information.

## Semi-Anonymization Principles

All transcripts must adhere to these principles:

1. **Speaker attribution** — Use `git config user.name` (or other git metadata) for speaker labels, not anonymous "human" or "assistant" generics
2. **No personal identifiers in content** — Remove names, email addresses, anecdotes, and personal preferences from message text
3. **Decision attribution is required** — Every decision must record who originated it: use `git config user.name` (e.g. `alice`) for the human participant; use `human` only as a last-resort fallback when git user.name is unavailable. Use `agent` for the AI assistant, or `joint` when both contributed equally.
4. **Depersonalized language** — Use "it was decided" rather than "I decided"; "was proposed" rather than "I proposed"
5. **Redact sensitive specifics** — Remove business details, user counts, financial info, or other context that might be identifying
6. **Preserve reasoning** — Keep the *why* behind decisions, just without the personal expressions

## Format

```markdown
# Transcript Summary: [Stage Title]

## Session Overview
[1-2 sentences: What was discussed and decided at a high level]

## Design Decisions Made

### Decision 1: [What was decided]
**Chosen:** [The option selected]
**Rationale:** [Why this was chosen over alternatives; focus on technical/business reasons]
**Tradeoffs:** [What was sacrificed or deferred]
**Key constraint:** [Any critical requirement that drove the decision, e.g., "GDPR compliance requirement"]
**Proposed by:** [git-user | agent | joint]

### Decision 2: [What was decided]
[Same structure as above]

## Issues/Questions Resolved
- [Issue 1: how it was explored and resolved]
- [Issue 2: what was clarified]

## Important Tradeoffs
[Broader tradeoffs discussed that affected multiple decisions]

## Deferred Items
[Things explicitly discussed but deferred to later stages]

## Process Notes
- [Any notes about how the design evolved or changed direction]
- [Blockers encountered and how they were resolved]
```

## Rules

1. **Summary, not transcript** — Condense the discussion, don't reproduce turn-by-turn conversation
2. **No personal pronouns or names** — Use passive voice or role-based language
3. **Always attribute decisions** — Every decision must have a `Proposed by` field: `git config user.name` (e.g. `alice`), `agent`, or `joint`; use `human` only as a last-resort fallback
4. **Technical clarity** — Explain options considered and why one was chosen; assume future readers are technical
5. **Brevity** — Typically 300–500 words; concise and scannable
5. **File naming:**
   - First transcript: `.transcript.md`
   - Additional transcripts: `.transcript-1.md`, `.transcript-2.md`, etc.
   - Stored within the stage folder alongside plan.md and tasks.md

## Example

```markdown
# Transcript Summary: Data Processing Pipeline

## Session Overview
The data processing pipeline design was discussed, focusing on a core tradeoff between using an external library for data validation versus implementing validation logic in-house. The decision was made to use an external library in order to reduce maintenance burden and leverage battle-tested code, accepting the additional dependency weight.

## Design Decisions Made

### Decision 1: External library vs in-house implementation for data validation
**Chosen:** Use the `jsonschema` external library for validation
**Rationale:** The library provides comprehensive JSON Schema support, reducing development time and maintenance burden. External libraries are better maintained and more performant than custom implementations.
**Tradeoffs:** Adds a runtime dependency, increases bundle size by ~150KB, and creates an external maintenance dependency. Mitigated by choosing a widely-used library with long-term stability.
**Key constraint:** Project targets minimal dependencies; bundle size is a concern for embedded use cases.
**Proposed by:** agent

### Decision 2: Validation schema architecture
**Chosen:** Centralized schema definitions in a single config file, loaded at startup
**Rationale:** Simplifies schema updates and testing; avoids scattering validation rules throughout the codebase. Single source of truth for schema evolution.
**Tradeoffs:** Less flexible for dynamic schema generation; requires application restart for schema changes. Deferred to v2 if dynamic schemas become critical.
**Alternatives considered:** Inline schemas (harder to maintain), database-backed schemas (adds complexity), environment-based schemas (harder to test).
**Proposed by:** joint

### Decision 3: Error handling for validation failures
**Chosen:** Validation failures return structured error responses with schema path information
**Rationale:** Enables client-side debugging and clearer error reporting. Structured errors allow programmatic handling.
**Tradeoffs:** More verbose responses; requires consistent error format documentation. Minimal performance impact.
**Proposed by:** alice

## Issues/Questions Resolved
- **Dependency bloat concern:** Raised risk of adding too many dependencies. Resolved by selecting one foundational validation library and deferring specialized tools to v2.
- **Performance uncertainty:** Clarified that `jsonschema` is comparable in speed to in-house implementations for the expected data volumes.

## Important Tradeoffs
The core tradeoff explored was developer velocity and correctness (via external library) versus minimal dependencies (in-house implementation). The chosen approach accepts the dependency weight in favor of maintainability and correctness.

## Deferred Items
- Custom validation rules layer deferred to v2
- Dynamic schema loading deferred pending adoption feedback
- Performance profiling for large payloads deferred to post-beta

## Process Notes
- Initial skepticism about external dependencies was the main discussion point
- Decision evolved through cost-benefit analysis of maintenance burden
- Team consensus reached that time saved outweighs the dependency cost
```

---

See [agent-instructions.md](agent-instructions.md) for when and how to create these summaries during a session.
