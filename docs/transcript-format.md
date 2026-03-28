# Transcript Format Specification

How to create anonymized transcript summaries for design stages.

## Purpose

Document key design decisions, rationale, and reasoning from a stage session. Transcripts are *summaries*, not raw recordings — designed to be readable by future contributors and appropriately semi-anonymized.

**Why a standard?** Design decision summaries should be readable, maintainable, and focused on the *thinking process* and *decisions made*, not the people involved. Speaker attribution uses git metadata (user.name), but message content is cleaned of personal expressions and identifying information.

## Semi-Anonymization Principles

All transcripts must adhere to these principles:

1. **Speaker attribution** — Use `git config user.name` (or other git metadata) for speaker labels, not anonymous "human" or "assistant" generics
2. **No personal identifiers in content** — Remove names, email addresses, anecdotes, and personal preferences from message text
3. **Decision-focused** — Document *what was decided and why*, not *who proposed it* (focus on decisions, not speakers)
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
3. **Technical clarity** — Explain options considered and why one was chosen; assume future readers are technical
4. **Brevity** — Typically 300–500 words; concise and scannable
5. **File naming:**
   - First transcript: `.transcript.md`
   - Additional transcripts: `.transcript-1.md`, `.transcript-2.md`, etc.
   - Stored within the stage folder alongside plan.md and tasks.md

## Example

```markdown
# Transcript Summary: Authentication System

## Session Overview
The authentication system design was discussed, exploring tradeoffs between simplicity and security. JWT tokens were selected as the foundation, with a hybrid approach to token revocation for immediate logout capability when needed.

## Design Decisions Made

### Decision 1: Token-based authentication (JWT)
**Chosen:** JWT tokens with bcrypt password hashing
**Rationale:** Stateless tokens reduce server complexity while scaling to thousands of users. Bcrypt provides strong password security with built-in salt handling.
**Tradeoffs:** Stateless design means no server-side token revocation without additional infrastructure; mitigated by short token lifetimes and refresh token mechanism.
**Key constraint:** System must scale to 10,000+ users; GDPR compliance required for EU user base.

### Decision 2: Token revocation approach
**Chosen:** Hybrid approach — short token lifetime (5–15 min) + optional revocation list for urgent logout
**Rationale:** Short lifetimes provide quick logout for most users without revocation overhead. Revocation list added for admin/security scenarios requiring immediate logout (compromised account, permissions change).
**Tradeoffs:** Adds operational complexity for revocation; partially mitigated by making it optional for v1.
**Alternatives considered:** Persistent sessions (higher server cost), long-lived tokens with revocation (all logouts incur cost), short tokens only (can't force immediate logout).

### Decision 3: User data minimization
**Chosen:** Collect only email and name; defer additional profile data
**Rationale:** Minimal data collection simplifies GDPR compliance (data retention, user export, deletion). Extensible if needed later.
**Tradeoffs:** Limits profile features in v1; planned as separate stage.

## Issues/Questions Resolved
- **Token revocation concern:** Raised risk of users being unable to log out immediately after account compromise. Resolved with hybrid approach: most logouts are fast (short lifetime), urgent cases handled by revocation list.
- **Scaling uncertainty:** Clarified expected user growth (1000 → 10k) and confirmed JWT's suitability at this scale.

## Important Tradeoffs
The session explored a fundamental tradeoff between stateless simplicity and immediate logout capability. The chosen hybrid approach accepts the complexity of an optional revocation mechanism to enable both statelessness and urgent logout scenarios.

## Deferred Items
- Revocation list implementation deferred to Phase 2 if urgent logout is needed in production
- Additional user profile fields deferred to separate stage
- SSO/federated auth deferred; only basic login in v1

## Process Notes
- Initial concern about token lifetime vs logout response was the main design challenge
- Decision evolved through option exploration to a hybrid approach, avoiding all-or-nothing tradeoff
- Architecture accommodates future GDPR audit well; minimal data retention burden
```

---

See [agent-instructions.md](agent-instructions.md) for when and how to create these summaries during a session.
