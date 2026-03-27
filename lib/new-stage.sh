#!/bin/bash

# Create a new spec stage
# Validates that previous stage retrospective is complete

spec_new_stage() {
  local stage_name="$1"

  if [ ! -d specs ]; then
    echo "Error: /specs directory not found. Run 'designlog init' first."
    exit 1
  fi

  # Find highest numbered stage
  local max_num=0
  for dir in specs/[0-9][0-9][0-9]-*; do
    if [ -d "$dir" ]; then
      num=$(basename "$dir" | cut -d- -f1)
      if [ "$num" -gt "$max_num" ]; then
        max_num=$num
      fi
    fi
  done

  # Check if previous stage has retrospective
  if [ "$max_num" -gt 0 ]; then
    printf -v prev_num "%03d" "$max_num"
    prev_dir=$(ls -d specs/$prev_num-* 2>/dev/null | head -1)
    if [ -d "$prev_dir" ] && [ ! -f "$prev_dir/design-decisions.md" ]; then
      echo "Warning: Previous stage ($prev_dir) has no design-decisions.md"
      echo "Run 'designlog retrospective' to generate design decisions first? (y/n)"
      read -r response
      if [ "$response" = "y" ]; then
        source "$(dirname "$0")/retrospective.sh"
        spec_retrospective
      else
        echo "Continuing without retrospective..."
      fi
    fi
  fi

  # Calculate next number
  local next_num=$((max_num + 1))
  printf -v padded_num "%03d" "$next_num"
  local stage_dir="specs/$padded_num-$stage_name"

  # Create stage directory
  mkdir -p "$stage_dir"

  # Create placeholder files
  cat > "$stage_dir/plan.md" << 'EOF'
# Plan: [Stage Title]

## Overview
(To be filled in)

## Context
(Previous decisions and constraints)

## Design Goals
- Goal 1
- Goal 2

## Proposed Approach
(High-level design decisions)

## Open Questions
(Anything to explore or clarify)
EOF

  cat > "$stage_dir/tasks.md" << 'EOF'
# Tasks: [Stage Title]

## Overview
(Brief description of work breakdown)

## Tasks

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Notes
(Any additional context)
EOF

  echo "✓ Created new stage: $stage_dir"
  echo ""
  echo "Next steps:"
  echo "  1. Edit $stage_dir/plan.md with the design plan"
  echo "  2. Edit $stage_dir/tasks.md with the task breakdown"
  echo "  3. Run 'designlog status' to see current state"
  echo "  4. Execute the tasks (implement the code changes)"
  echo "  5. Run 'designlog retrospective' to generate design-decisions.md"
  echo ""
  echo "Remember to record the session transcript in $stage_dir/.transcript.md"
}
