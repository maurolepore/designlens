#!/bin/bash

# Begin implementation of the current stage's tasks.md

lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_implement() {
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
      if [ $((10#$num)) -gt "$max_num" ]; then
        max_num=$((10#$num))
      fi
    fi
  done

  if [ "$max_num" -eq 0 ]; then
    error "No stages found. Run 'designlens new-stage' first."
    exit 1
  fi

  local padded_num
  padded_num=$(printf "%03d" "$max_num")
  local stage_dir
  stage_dir=$(ls -d specs/$padded_num-* 2>/dev/null | head -1)

  if [ ! -f "$stage_dir/tasks.md" ]; then
    error "No tasks.md found in $stage_dir. Run 'designlens make-tasks' first."
    exit 1
  fi

  echo ""
  echo "AGENT: Implement all tasks listed in $stage_dir/tasks.md, in order, one by one."
  echo ""
  echo "Rules:"
  echo "  1. Work through tasks sequentially — do not skip or reorder."
  echo "  2. Implementation is not complete until every task is checked off."
  echo "  3. If any uncertainty arises — including potential conflicts between tasks,"
  echo "     ambiguous requirements, or unexpected obstacles — stop and ask the user"
  echo "     for clarification before proceeding."
  echo "  4. Once all tasks are complete, tell the user to run: designlens retrospective"
}
