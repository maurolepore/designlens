#!/bin/bash

# Begin implementation of the current stage's tasks.md

lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"
source "$lib_dir/config.sh"

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
  echo "Tasks are identified by IDs of the form T${padded_num}-N (e.g. T${padded_num}-1, T${padded_num}-2, ...)."
  echo ""
  echo "Rules:"
  echo "  1. Work through tasks sequentially by ID — do not skip or reorder."
  echo "  2. Mark each checkbox as complete (- [x]) immediately upon finishing that task."
  echo "  3. Do not stop or pause between tasks for any reason other than to request"
  echo "     clarification from the user (see rule 4)."
  echo "  4. If any uncertainty arises — including potential conflicts between tasks,"
  echo "     ambiguous requirements, or unexpected obstacles — pause and ask the user"
  echo "     for clarification before proceeding. Resume immediately once resolved."
  echo "  5. Implementation is not complete until every checkbox in $stage_dir/tasks.md"
  echo "     is checked. Do not report completion while any checkbox remains unchecked."
  echo ""
  echo "On completion:"
  echo "  a. Run: git add $stage_dir/plan.md $stage_dir/tasks.md"

  local auto_commit
  auto_commit=$(get_config "auto_commit" 2>/dev/null)

  if [ "$auto_commit" = "true" ]; then
    echo "  b. Ask the user: 'Generate retrospective before committing stage $padded_num specs? (y/n)'"
    echo "     - If y: run 'designlens retrospective', then commit everything:"
    echo "         git add $stage_dir/"
    echo "         git commit -m \"$padded_num: Add specs and design decisions\""
    echo "     - If n: ask 'Run retrospective anyway without committing? (y/n)'"
    echo "         - If y: run 'designlens retrospective' and stop (no commit)."
    echo "         - If n: stop."
  else
    echo "  b. Tell the user to run: designlens retrospective"
  fi
}
