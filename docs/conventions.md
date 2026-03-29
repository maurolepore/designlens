# designlens Conventions

This document defines the complete designlens workflow and file structure. It links to detailed guides for specific topics.

## Overview

designlens is a design history tool for open source projects. It captures the progression from rough ideas → formalized plans → task breakdown → implementation → retrospective decisions.

The core value: future contributors can understand *why* the code is the way it is, not just *what* it does.

### Key Principle

Every design stage produces three artifacts:
- **plan.md** — The design vision (what and why)
- **tasks.md** — The execution breakdown (how)
- **design-decisions.md** — The reasoning summary, integrated with prior work (why we chose this path, and how it builds on earlier decisions)

Combined with session transcript summaries, these form a complete archaeological record of the project's evolution. Each `design-decisions.md` documents what's new in that stage while cross-referencing prior decisions to show how the design evolves—keeping each document concise without losing the narrative arc.

## Folder Structure

```
your-project/
  specs/
    README.md
    001-initial-concept/
      plan.md
      tasks.md
      design-decisions.md
      .transcript.md
    002-auth-system/
      plan.md
      tasks.md
      design-decisions.md
      .transcript.md
    003-...
  .designlens.json
  AGENTS.md (or CLAUDE.md)
  ...
```

### Key Points

- **specs/** is the public design record, committed to git
- Each stage folder is numbered with a 3-digit prefix (001, 002, etc.)
- Within each stage: everything is self-contained
- **.designlens.json** contains tool metadata and project-specific config (recommended to commit)
- **AGENTS.md/CLAUDE.md** points agents to the specs on session start
- **Transcripts** (`.transcript.md`) are semi-anonymized session records: speaker labels use git user.name, message content is anonymized. They document *what* was decided and *why*, safe for public repos

### Handling Parallel Development

If two branches diverge at the same stage (e.g., both have `001-*`), that's fine:
- Git tracks which branch merged
- The folder names can have suffixes: `001-feature-a`, `001-feature-b`
- Duplicate numeric prefixes signal parallel exploration, which is meaningful design history

When one branch merges and another diverges, the history naturally captures the divergence and resolution.

---

## Documentation Links

- **[workflow.md](workflow.md)** — The 6-phase workflow (initialize → plan → implement → retrospective → commit → repeat)
- **[file-formats.md](file-formats.md)** — Templates and style guides for plan.md, tasks.md, design-decisions.md, and .transcript.md
- **[agent-instructions.md](agent-instructions.md)** — How agents should work with designlens at each phase
- **[transcript-format.md](transcript-format.md)** — Detailed specification for transcript summaries, semi-anonymization rules, and examples
- **[faq.md](faq.md)** — Frequently asked questions, tools reference, and Git workflow examples

---

## Quick Start

1. **Terminal (once per project):**
   ```bash
   designlens init
   ```
   (initializes git if needed)

2. **In an agent session:**
   ```bash
   designlens status
   ```
   The status command tells you what to do next at every stage.

3. **During work:**
   - Agent reads [workflow.md](workflow.md) to understand phases
   - Agent uses templates from [file-formats.md](file-formats.md) when writing plan.md, tasks.md, design-decisions.md
   - Agent follows [agent-instructions.md](agent-instructions.md) for session behavior
   - Agent creates semi-anonymized transcripts using [transcript-format.md](transcript-format.md) as a reference

---

See the project's `/specs` folder for real examples.
