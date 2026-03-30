#!/bin/bash

# Helper for creating semi-anonymized session transcripts
# Speaker attribution uses git user.name; message content is anonymized

# Source colors and logo
lib_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$lib_dir/colors.sh"
source "$lib_dir/logo.sh"

spec_transcript() {
  local input_file="$1"

  local git_user
  git_user=$(git config user.name 2>/dev/null || echo "unknown")

  if [ ! -f "$input_file" ]; then
    # CREATE MODE: instruct agent to create the transcript from scratch
    heading "============================================"
    echo ""
    echo "## SUB-TASK: Create session transcript"
    echo ""
    echo "Create a semi-anonymized summary transcript of this design session."
    echo "Save it to: $input_file"
    echo ""
    echo "### Format:"
    echo ""
    echo "# Session Transcript: [Stage Title]"
    echo ""
    echo "## Session Overview"
    echo "[1-2 sentences summarizing what was discussed and decided]"
    echo ""
    echo "## Key Decisions"
    echo "- [Decision 1]: [Brief rationale]"
    echo "- [Decision 2]: [Brief rationale]"
    echo ""
    echo "## Tradeoffs Considered"
    echo "- [Option A vs Option B]: [Why the chosen option won]"
    echo ""
    echo "## Open Questions"
    echo "- [Any unresolved questions or deferred items]"
    echo ""
    echo "### ANONYMIZATION REQUIREMENTS (non-negotiable):"
    echo "- Speaker labels: use git user.name ($git_user), not 'human', 'user', or real names"
    echo "- NO personal expressions, anecdotes, or preferences in first person"
    echo "- NO email addresses or identifying information"
    echo "- NO user counts, revenue, or business-specific details"
    echo "- Focus on technical reasoning and decisions, not speakers"
    echo ""
    echo "### Length: 150–300 words. Concise and scannable."
    echo ""
    heading "============================================"
    return
  fi

  heading "Transcript semi-anonymization review"
  echo ""
  info "Note: designlens transcripts are SUMMARIES of design decisions, not raw conversation."
  info "They must be semi-anonymized before being committed to a project repo:"
  echo ""
  echo "  Speaker labels : use git user.name ($git_user)"
  echo "  Message content: anonymized — remove personal expressions and identifying info"
  echo ""
  heading "Checklist:"
  echo "  ☐ Speaker labels use git user.name (not 'human' or 'user')"
  echo "  ☐ No personal expressions or anecdotes in message content"
  echo "  ☐ No email addresses or identifiers in message content"
  echo "  ☐ No personal preferences stated in first person"
  echo "  ☐ No user counts, revenue, or business-specific details that identify the company"
  echo "  ☐ Focuses on technical reasoning and decisions, not personal opinions"
  echo "  ☐ Follows the structured format (Session Overview, Decisions, Tradeoffs, etc.)"
  echo ""
  prompt "Edit the file manually to remove any identifying information from message content:"
  echo "  $input_file"
  echo ""
  prompt "Verify compliance with:"
  echo "  grep -E '(email|@|facebook|twitter|slack|company|revenue|users?)' $input_file"
}
