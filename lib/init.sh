#!/bin/bash

# Initialize a project to use designlog
# Creates /specs folder, lockfile, and AGENTS.md pointer

spec_init() {
  if [ ! -d .git ]; then
    echo "Error: Not a git repository. Initialize git first with 'git init'"
    exit 1
  fi

  if [ -d specs ]; then
    echo "Error: /specs folder already exists. Project is already initialized."
    exit 1
  fi

  echo "Initializing designlog project..."

  # Create /specs directory
  mkdir -p specs
  echo "✓ Created /specs directory"

  # Read metadata from installed tool
  METADATA_FILE="${LIB_DIR}/../designlog.json"
  if [ -f "$METADATA_FILE" ]; then
    TOOL_VERSION=$(grep -o '"Version": *"[^"]*"' "$METADATA_FILE" | cut -d'"' -f4)
    TOOL_URL=$(grep -o '"URL": *"[^"]*"' "$METADATA_FILE" | cut -d'"' -f4)
  else
    TOOL_VERSION="unknown"
    TOOL_URL="https://github.com/ropensci/designlog"
  fi

  # Create lockfile
  cat > .specmeta.json << EOF
{
  "tool": "designlog",
  "version": "$TOOL_VERSION",
  "docs": "$TOOL_URL/blob/main/docs/conventions.md",
  "active": true
}
EOF
  echo "✓ Created .specmeta.json lockfile"

  # Create specs README
  cat > specs/README.md << 'EOF'
# Project Specs

This directory contains the design history and specification documents for this project.

Each numbered folder represents a design stage:

- **plan.md** — The design for this stage (what we're building and why)
- **tasks.md** — Breakdown into actionable tasks
- **decisions.md** — Auto-generated summary of design decisions made during this stage
- **.transcript.md** — Raw session transcript(s) from the agent/developer conversation

## How to read these specs

Start with the most recent numbered folder. Read plan.md first for the overall intention, then tasks.md for the breakdown, then decisions.md for the reasoning behind specific choices.

The transcript files contain the full conversation history and are useful for understanding edge cases or decisions that were discussed but not chosen.

## Using these specs

These files are part of the repository and are committed to git. They serve as documentation for future contributors, showing not just what code was written, but why architectural decisions were made.

For instructions on *creating* new specs, see the project's AGENTS.md or CLAUDE.md file.
EOF
  echo "✓ Created specs/README.md"

  # Ask about capturing existing design history
  echo ""
  echo "Capture existing design history from git log? (y/n)"
  read -r capture_history
  if [ "$capture_history" = "y" ]; then
    mkdir -p specs/000-dev-history
    echo "✓ Created specs/000-dev-history/"
    echo ""
    echo "Copy this prompt into your agent to generate design history:"
    echo ""
    echo "============================================"
    echo ""
    cat << 'EOF'
Analyze this project's git history and generate a design-history.md file
summarizing its architectural evolution.

Run these commands to explore the history:

```bash
git log --oneline --all | head -100
git log --all --oneline --stat | head -100
git log --all --oneline --since="1 year ago"
git log --all --oneline --grep="feature\|design\|architecture\|refactor"
```

Then examine key commits with: git show <hash>

Create specs/000-dev-history/design-history.md that documents:

1. **Project Evolution** - Major phases and architectural decisions
2. **Key Decisions** - Strategic choices that shaped the codebase
   - What was decided
   - Why (constraints, requirements at the time)
   - Impact (what changed)

Focus on:
- Initial architecture and core design choices
- Major refactors or architectural changes
- Significant feature additions that changed direction
- Technology/dependency decisions
- Changes in development approach or patterns

Avoid:
- Documenting every commit
- Minor bug fixes or small improvements
- Implementation details (focus on why, not what)

Keep it concise (~300-500 words). Cherry-pick the most important decisions
and changes, using git history as the source but making strategic choices
about what's worth documenting for future contributors.

Output the file to: specs/000-dev-history/design-history.md
EOF
    echo ""
    echo "============================================"
  fi

  # Detect and create AGENTS.md / CLAUDE.md
  if [ -f "AGENTS.md" ]; then
    echo ""
    echo "AGENTS.md already exists. Append designlog reference? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
      cat >> AGENTS.md << 'EOF'

## designlog

This project uses **designlog** for design history tracking. Read the specs in `/specs` and `/docs/conventions.md` (if present) for the development workflow and design decisions.
EOF
      echo "✓ Appended to AGENTS.md"
    fi
  elif [ -f "CLAUDE.md" ]; then
    echo ""
    echo "CLAUDE.md already exists. Append designlog reference? (y/n)"
    read -r response
    if [ "$response" = "y" ]; then
      cat >> CLAUDE.md << 'EOF'

## speclog

This project uses **designlog** for design history tracking. Read the specs in `/specs` for the development workflow and design decisions.
EOF
      echo "✓ Appended to CLAUDE.md"
    fi
  else
    # Create AGENTS.md
    cat > AGENTS.md << 'EOF'
# Agent Instructions

## designlog

This project uses **designlog** for design history tracking.

When starting a session:
1. Read `/specs/README.md` to understand the current project state
2. Check the latest numbered stage folder for plan.md, tasks.md, and decisions.md
3. Run `designlog status` to see what's next
4. Follow the guidance in `/docs/conventions.md` for the workflow

The specs folder contains the full design history and development philosophy. Refer to it when making architectural decisions.
EOF
    echo "✓ Created AGENTS.md"
  fi

  echo ""
  echo "✓ designlog initialized successfully!"
  echo ""
  echo "Next steps:"
  echo "  1. Commit the changes: git add -A && git commit -m 'Initialize designlog'"
  echo "  2. Start a coding session with your agent (Claude Code, etc.)"
  echo "  3. Run 'designlog new-stage \"name\"' to begin the first design phase"
}
