#!/bin/bash

# Create a new spec stage
# Validates that previous stage retrospective is complete

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_new_stage() {
  local stage_description="$1"
  local stage_name="$2"

  show_logo

  if [ ! -d specs ]; then
    error "/specs directory not found. Run 'designlens init' first."
    exit 1
  fi

  if [ -z "$stage_description" ]; then
    echo ""
    echo "AGENT: No description provided. Ask the user what they want to build in this stage."
    echo "Keep asking clarifying questions until you have enough detail to write a concrete,"
    echo "actionable plan. Then call: designlens new-stage \"<full description>\""
    echo ""
    exit 0
  fi

  # Derive a slug from the description if no name was provided
  if [ -z "$stage_name" ]; then
    stage_name=$(echo "$stage_description" \
      | tr '[:upper:]' '[:lower:]' \
      | tr -cs 'a-z0-9' '-' \
      | sed 's/-\+/-/g; s/^-//; s/-$//' \
      | cut -d- -f1-2)
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
    local prev_num
    prev_num=$(printf "%03d" "$max_num")
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
  local padded_num
  padded_num=$(printf "%03d" "$next_num")
  local stage_dir="specs/$padded_num-$stage_name"

  # Create stage directory
  mkdir -p "$stage_dir"

  # Create plan.md
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

  success "Created $stage_dir/plan.md"
  echo ""
  echo "AGENT: plan.md has been created with the description as a starting point."
  echo "Tell the user to review and edit $stage_dir/plan.md until they are happy with it."
  echo "Once they are done, they should run: designlens make-tasks"
}
