#!/bin/bash

# Generate tasks.md from the current stage's plan.md

lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_make_tasks() {
  show_logo

  if [ ! -d specs ]; then
    error "/specs directory not found. Run 'designlens init' first."
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

  if [ "$max_num" -eq 0 ]; then
    error "No stages found. Run 'designlens new-stage' first."
    exit 1
  fi

  printf -v padded_num "%03d" "$max_num"
  local stage_dir
  stage_dir=$(ls -d specs/$padded_num-* 2>/dev/null | head -1)

  if [ ! -f "$stage_dir/plan.md" ]; then
    error "No plan.md found in $stage_dir. Run 'designlens new-stage' first."
    exit 1
  fi

  if [ -f "$stage_dir/tasks.md" ]; then
    warning "tasks.md already exists in $stage_dir."
    prompt "Overwrite? (y/n)"
    read -r response
    if [ "$response" != "y" ]; then
      echo "Aborted."
      exit 0
    fi
  fi

  echo ""
  echo "AGENT: Read $stage_dir/plan.md and generate $stage_dir/tasks.md from it."
  echo "Break the plan into concrete, actionable tasks with checkboxes."
  echo "Once written, tell the user to review tasks.md and begin implementation."
}
