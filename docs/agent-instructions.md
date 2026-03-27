# Agent Instructions

How to work with designlog during a coding session.

## At Session Start

1. **Check for spec setup:**
   ```bash
   designlog status
   ```

2. **Read the current state:**
   - If no stages exist, work with the human to start the first stage
   - If a stage has no plan.md, help the human develop the design
   - If a stage has no tasks.md, break the plan into tasks
   - If tasks are incomplete, help execute them
   - If all tasks are done but no design-decisions.md exists, run the retrospective

## During the Session

1. **Follow designlog conventions**
   - When writing plan.md, use the template in [file-formats.md](file-formats.md)
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
   - Run `designlog status` periodically to show progress

4. **Record the conversation**
   - If the human asks, or if significant design decisions were made, save a normalized transcript to `.transcript.md`
   - Use the standard format (Turn N, human:/assistant: labels)

## When the Stage Is Complete

1. **Confirm all tasks are done:**
   - Run `designlog status` — it should say "Stage complete!"

2. **Generate design-decisions.md:**
   - Run `designlog retrospective`
   - Follow the detailed prompt it provides
   - **Critical:** Follow anonymization rules strictly
     - No personal names or identifying information
     - No personal anecdotes or preferences
     - Role-based language only ("a contributor decided", not "Mark decided")
     - Focus on technical reasoning, not people
   - Create a structured summary of key decisions, rationale, and tradeoffs
   - Typically 300–500 words, scannable format

3. **Guide the human to commit:**
   ```bash
   git add specs/NNN-stage-name/
   git commit -m "NNN-stage-name: Design decisions and implementation"
   ```

4. **Start the next stage:**
   - Ask the human what to work on next
   - Run `designlog new-stage "next-stage-name"`
   - Begin planning again

## Key Principles

- **Specs are for humans first:** Write them clearly, as if a contributor 6 months from now will read them
- **Anonymize ruthlessly:** No personal identifying information in transcripts — they're part of the project's public record
- **Focus on decisions, not people:** What was decided and why, not who proposed it
- **Mark uncertainty:** Don't pretend to be certain when you're not; use "Open Questions"
- **Facilitate, don't control:** The human makes the design calls; your job is to explore, propose, and document
- **Preserve reasoning:** Keep the *why* behind decisions, even after anonymization

---

See [transcript-format.md](transcript-format.md) for detailed guidance on creating anonymized transcripts and [workflow.md](workflow.md) for the overall phase structure.
