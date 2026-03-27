#!/bin/bash

# Generate decisions.md from the current stage
# Uses agent to summarize design decisions from plan and transcript

spec_retrospective() {
  if [ ! -d specs ]; then
    echo "Error: /specs directory not found. Run 'speclog init' first."
    exit 1
  fi

  # Find latest stage
  local latest_stage=""
  for dir in specs/[0-9][0-9][0-9]-*; do
    if [ -d "$dir" ]; then
      latest_stage="$dir"
    fi
  done

  if [ -z "$latest_stage" ]; then
    echo "Error: No stages found."
    exit 1
  fi

  # Check if decisions.md already exists
  if [ -f "$latest_stage/decisions.md" ]; then
    echo "decisions.md already exists for $latest_stage"
    echo "Overwrite? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
      exit 0
    fi
  fi

  # Check for required files
  if [ ! -f "$latest_stage/plan.md" ]; then
    echo "Error: plan.md not found in $latest_stage"
    exit 1
  fi

  if [ ! -f "$latest_stage/tasks.md" ]; then
    echo "Error: tasks.md not found in $latest_stage"
    exit 1
  fi

  echo "Generating decisions.md for $latest_stage..."
  echo ""
  echo "Copy this prompt into your agent (Claude Code, etc.) to generate decisions.md:"
  echo ""
  echo "============================================"
  echo ""
  echo "You are reviewing a completed design stage for a project."
  echo ""
  echo "Generate a SUMMARY TRANSCRIPT (not raw conversation) that documents key design"
  echo "decisions and reasoning. This will be committed to the repo and read by future"
  echo "contributors, so DEPERSONALIZATION IS CRITICAL."
  echo ""
  echo "Read the following documents:"
  echo ""
  cat "$latest_stage/plan.md"
  echo ""
  echo "---"
  echo ""
  cat "$latest_stage/tasks.md"
  echo ""

  # Include existing transcript if it exists
  if [ -f "$latest_stage/.transcript.md" ]; then
    echo "---"
    echo ""
    echo "Session transcript summary (for reference):"
    echo ""
    cat "$latest_stage/.transcript.md"
    echo ""
  fi

  echo "---"
  echo ""
  echo "## INSTRUCTIONS"
  echo ""
  echo "Generate a structured summary transcript called 'decisions.md' following these rules:"
  echo ""
  echo "### ANONYMIZATION REQUIREMENTS (non-negotiable):"
  echo "- NO personal names, email addresses, or identifying information"
  echo "- NO references to individuals (use 'a contributor' or 'the human' if needed, not 'Mark' or 'John')"
  echo "- NO personal details, preferences, or anecdotes"
  echo "- Use PASSIVE VOICE or ROLE-BASED language (e.g., 'was decided', 'was proposed')"
  echo "- Remove business/user info that could identify the company (e.g., user counts, revenue)"
  echo "- Focus on TECHNICAL AND REASONING aspects, not the people"
  echo ""
  echo "### FORMAT (from conventions.md):"
  echo "# Transcript Summary: [Stage Title]"
  echo ""
  echo "## Session Overview"
  echo "[1-2 sentences of what was discussed and decided]"
  echo ""
  echo "## Design Decisions Made"
  echo "### Decision 1: [What was decided]"
  echo "**Chosen:** [The option selected]"
  echo "**Rationale:** [Why; focus on technical/business reasons, not who proposed]"
  echo "**Tradeoffs:** [What was sacrificed]"
  echo ""
  echo "### Decision 2: [What was decided]"
  echo "[Same structure]"
  echo ""
  echo "## Issues/Questions Resolved"
  echo "- [Issue: how it was resolved]"
  echo ""
  echo "## Important Tradeoffs"
  echo "[Broader tradeoffs affecting multiple decisions]"
  echo ""
  echo "## Deferred Items"
  echo "[Things discussed but deferred to later stages]"
  echo ""
  echo "## Process Notes"
  echo "- [How design evolved or changed direction]"
  echo "- [Blockers encountered]"
  echo ""
  echo "### What NOT to include:"
  echo "- Names, email, or personal identifiers"
  echo "- Turn-by-turn raw conversation"
  echo "- Personal anecdotes or preferences"
  echo "- Who said what (focus on decisions, not speakers)"
  echo "- Sensitive business info (user counts, revenue, specific dates)"
  echo ""
  echo "### Length:"
  echo "300–500 words typically. Concise, scannable, focused on reasoning."
  echo ""
  echo "Save the result to: $latest_stage/.transcript.md"
  echo "============================================"
  echo ""
  echo "After generating .transcript.md, commit the changes:"
  echo "  git add $latest_stage/"
  echo "  git commit -m \"$latest_stage: Add design decisions\""
}
