#!/bin/bash

# Generate design-decisions.md from the current stage
# Uses agent to summarize design decisions from plan and transcript

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_retrospective() {
  show_logo

  if [ ! -d specs ]; then
    error "/specs directory not found. Run 'designlens init' first."
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
    error "No stages found."
    exit 1
  fi

  # Check if design-decisions.md already exists
  if [ -f "$latest_stage/design-decisions.md" ]; then
    warning "design-decisions.md already exists for $latest_stage"
    prompt "Overwrite? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
      exit 0
    fi
  fi

  # Check for required files
  if [ ! -f "$latest_stage/plan.md" ]; then
    error "plan.md not found in $latest_stage"
    exit 1
  fi

  if [ ! -f "$latest_stage/tasks.md" ]; then
    error "tasks.md not found in $latest_stage"
    exit 1
  fi

  heading "Generating design-decisions.md for $latest_stage..."
  echo ""
  info "After implementing all tasks, review with agent to generate design-decisions.md:"
  echo ""
  heading "============================================"
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

  # Include previous design decisions for context
  echo "---"
  echo ""
  echo "## CONTEXT: Previous Design Decisions"
  echo ""
  echo "This stage builds on previous work. Review the following design decisions"
  echo "to understand how this stage integrates with the overall project evolution:"
  echo ""

  # Include design history if it exists
  if [ -f "specs/000-design-history/design-decisions.md" ]; then
    echo "### Project Foundation (000-design-history)"
    echo ""
    cat "specs/000-design-history/design-decisions.md"
    echo ""
    echo "---"
    echo ""
  fi

  # Include all previous numbered stages' design decisions
  local stage_num=$(basename "$latest_stage" | cut -d- -f1)
  for dir in specs/[0-9][0-9][0-9]-*; do
    if [ -d "$dir" ]; then
      prev_num=$(basename "$dir" | cut -d- -f1)
      # Only include if it's before the current stage
      if [ "$prev_num" -lt "$stage_num" ] && [ -f "$dir/design-decisions.md" ]; then
        stage_title=$(basename "$dir")
        echo "### $stage_title"
        echo ""
        cat "$dir/design-decisions.md"
        echo ""
        echo "---"
        echo ""
      fi
    fi
  done

  echo "---"
  echo ""
  echo "## INSTRUCTIONS"
  echo ""
  echo "Generate a design-decisions.md that:"
  echo "1. Documents NEW decisions made in THIS stage"
  echo "2. Integrates with and builds on the previous design decisions above"
  echo "3. Cross-references previous stages where relevant (e.g., 'building on the auth system from 001-...')"
  echo "4. Maintains brevity by pointing to previous docs for context rather than repeating"
  echo "5. Shows how this stage advances the overall project architecture"
  echo ""
  echo "Structure: Include only what's NEW in this stage. For how it relates to prior work,"
  echo "use cross-references like: 'See 001-stage-name/design-decisions.md for the foundational"
  echo "decision on X, which this stage extends by Y.'"
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
  echo "# Design Decisions: [Stage Title]"
  echo ""
  echo "## Summary"
  echo "[1-2 sentences of what was accomplished and the key decisions made]"
  echo ""
  echo "## New Design Decisions"
  echo "### Decision 1: [What was decided in THIS stage]"
  echo "**Chosen:** [The option selected]"
  echo "**Rationale:** [Why; focus on technical/business reasons]"
  echo "**Tradeoffs:** [What was sacrificed]"
  echo "**Relates to:** [Brief cross-ref if building on prior work, e.g., 'See 001-foo for foundation']"
  echo ""
  echo "### Decision 2: [What was decided]"
  echo "[Same structure]"
  echo ""
  echo "## Integration with Prior Work"
  echo "[How this stage's decisions connect to and build on previous stages.]"
  echo "[Example: 'The auth system from 001-auth builds on the core architecture from 000-design-history']"
  echo "[This section is brief; most detail is in the earlier docs.]"
  echo ""
  echo "## Issues Resolved"
  echo "- [Issue from plan.md: how it was resolved]"
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
  echo "200–400 words typically. Concise and scannable. AVOID repeating decisions from"
  echo "prior stages; instead cross-reference them. This keeps each stage's doc brief"
  echo "and focused on what's NEW, while the full history is reconstructable by reading"
  echo "sequentially from 000-design-history forward."
  echo ""
  info "Save the result to: $latest_stage/design-decisions.md"
  heading "============================================"
  echo ""
  info "After generating .transcript.md, commit the changes:"
  echo "  git add $latest_stage/"
  echo "  git commit -m \"$latest_stage: Add design decisions\""
  echo ""
  info "Once the retrospective is committed, run: designlens new-stage"
}
