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
  echo "You are reviewing a completed design stage for a project."
  echo ""
  echo "Read the following documents:"
  echo ""
  cat "$latest_stage/plan.md"
  echo ""
  echo "---"
  echo ""
  cat "$latest_stage/tasks.md"
  echo ""

  # Include transcript if it exists
  if [ -f "$latest_stage/.transcript.md" ]; then
    echo "---"
    echo ""
    echo "Session transcript:"
    echo ""
    cat "$latest_stage/.transcript.md"
    echo ""
  fi

  echo "---"
  echo ""
  echo "Now generate a 'decisions.md' file that summarizes:"
  echo ""
  echo "1. Key design decisions made (what was chosen and why)"
  echo "2. Important tradeoffs discussed"
  echo "3. Attribution: Which decisions came from humans vs AI"
  echo "4. Open questions or items deferred to later stages"
  echo ""
  echo "Format as markdown with clear sections. Keep it concise (under 500 words)."
  echo "Save the output to: $latest_stage/decisions.md"
  echo "============================================"
  echo ""
  echo "After generating decisions.md, commit the changes:"
  echo "  git add $latest_stage/"
  echo "  git commit -m \"$latest_stage: Add design decisions\""
}
