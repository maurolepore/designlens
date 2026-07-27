#!/bin/bash

# Counts git commits since the most recent designlens stage's git_hash.
# Outputs:
#   count=<N>
#   threshold=<M>
#   total_commits=<T>  (total commits in the repo's history, regardless of stage)
# Exits 1 if count >= threshold, 0 otherwise.

commits_since_stage() {
  # Read threshold from .designlens.json, default 10
  local threshold=10
  if command -v jq &>/dev/null && [ -f .designlens.json ]; then
    local jq_val
    jq_val=$(jq -r '.retrospective_threshold // empty' .designlens.json 2>/dev/null)
    if [ -n "$jq_val" ] && [ "$jq_val" != "null" ]; then
      threshold="$jq_val"
    fi
  fi

  # Total commits in the repo, used to detect brand-new repos that don't
  # yet have enough history for a meaningful retrospective.
  local total_commits
  total_commits=$(git rev-list --count HEAD 2>/dev/null || echo "0")

  # Find the most recent stage directory that has a design-decisions.md
  local latest_dd=""
  for dir in $(find specs -maxdepth 1 -type d -name '[0-9][0-9][0-9]-*' 2>/dev/null | sort -r); do
    if [ -f "$dir/design-decisions.md" ]; then
      latest_dd="$dir/design-decisions.md"
      break
    fi
  done

  # If no stage with design-decisions.md found, nothing to count from
  if [ -z "$latest_dd" ]; then
    echo "count=0"
    echo "threshold=$threshold"
    echo "total_commits=$total_commits"
    exit 0
  fi

  # Extract git_hash from YAML front-matter
  local git_hash
  git_hash=$(grep -m1 '^git_hash:' "$latest_dd" | sed 's/^git_hash:[[:space:]]*//' | tr -d '[:space:]')

  if [ -z "$git_hash" ]; then
    echo "count=0"
    echo "threshold=$threshold"
    echo "total_commits=$total_commits"
    exit 0
  fi

  # Count commits since that hash
  local count
  count=$(git rev-list "${git_hash}..HEAD" --count 2>/dev/null || echo "0")

  echo "count=$count"
  echo "threshold=$threshold"
  echo "total_commits=$total_commits"

  if [ "$count" -ge "$threshold" ]; then
    exit 1
  fi
  exit 0
}
