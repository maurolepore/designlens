#!/bin/bash

# Create a new spec stage
# Validates that previous stage retrospective is complete

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_new_stage() {
  local stage_name="$1"
  local stage_description="$2"

  show_logo

  if [ ! -d specs ]; then
    error "/specs directory not found. Run 'designlens init' first."
    exit 1
  fi

  if [ -z "$stage_name" ] || [ -z "$stage_description" ]; then
    error "Usage: designlens new-stage <verb-noun> <description>"
    echo ""
    echo "  Both arguments are required:"
    echo "    <verb-noun>    A short slug, e.g. 'add-auth', 'refactor-parser'"
    echo "    <description>  A description of what this stage will accomplish"
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
      warning "Previous stage ($prev_dir) has no design-decisions.md"
      prompt "Run 'designlens retrospective' to generate design decisions first? (y/n)"
      read -r response
      if [ "$response" = "y" ]; then
        source "$(dirname "$0")/retrospective.sh"
        spec_retrospective
      else
        warning "Continuing without retrospective..."
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
  cat > "$stage_dir/plan.md" << EOF
# Plan: $stage_name

## Overview
$stage_description

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

  cat > "$stage_dir/tasks.md" << EOF
# Tasks: $stage_name

## Overview
(Brief description of work breakdown)

## Tasks

- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Notes
(Any additional context)
EOF

  success "Created new stage: $stage_dir"
  echo ""
  heading "Next steps:"
  echo "  1. Edit $stage_dir/plan.md with the design plan"
  echo "  2. Edit $stage_dir/tasks.md with the task breakdown"
  echo "  3. Run 'designlens status' to see current state"
  echo "  4. Execute the tasks (implement the code changes)"
  echo "  5. Run 'designlens retrospective' to generate design-decisions.md"
  echo ""
  info "Remember to record the session transcript in $stage_dir/.transcript.md"
}
