#!/bin/bash

# Project emptiness detection for designlens
# Used to determine if a project has real content beyond designlens infrastructure

# Define designlens infrastructure paths to ignore
DESIGNLENS_PATHS=".designlens.json AGENTS.md specs .git .claude .opencode"

# Check if a path is a designlens infrastructure path
is_designlens_path() {
  local path="$1"
  for design_path in $DESIGNLENS_PATHS; do
    if [ "$path" = "$design_path" ]; then
      return 0
    fi
    if [[ "$path" == "$design_path"/* ]]; then
      return 0
    fi
  done
  return 1
}

# Check git history for non-designlens commits
# Returns 0 if project has real content (non-designlens commits), 1 if trivial
check_git_history() {
  if ! git rev-parse --git-dir > /dev/null 2>&1; then
    return 1
  fi

  local commit_count
  commit_count=$(git rev-list --count --all 2>/dev/null)

  if [ -z "$commit_count" ] || [ "$commit_count" -eq 0 ]; then
    return 1
  fi

  local files
  files=$(git log --name-only --pretty=format:"" 2>/dev/null)

  for file in $files; do
    if [ -n "$file" ] && ! is_designlens_path "$file"; then
      return 0
    fi
  done

  return 1
}

# Check filesystem for non-designlens files
# Returns 0 if project has real content (non-infrastructure files), 1 if empty
check_filesystem() {
  local old_shopt
  old_shopt=$(shopt -p dotglob 2>/dev/null)
  shopt -s dotglob

  local found=false
  for item in *; do
    if [ -e "$item" ] && ! is_designlens_path "$item"; then
      found=true
      break
    fi
  done

  eval "$old_shopt" 2>/dev/null

  if [ "$found" = true ]; then
    return 0
  fi
  return 1
}

# Main function: Check if project has real content
# Returns 0 if non-empty, 1 if empty
is_project_empty() {
  if check_git_history; then
    return 1
  fi

  if check_filesystem; then
    return 1
  fi

  return 0
}