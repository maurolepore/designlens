#!/bin/bash

# Helper for creating semi-anonymized session transcripts
# Speaker attribution uses git user.name; message content is anonymized

spec_transcript() {
  local input_file="$1"

  if [ ! -f "$input_file" ]; then
    echo "Error: File not found: $input_file"
    exit 1
  fi

  local git_user
  git_user=$(git config user.name 2>/dev/null || echo "unknown")

  echo "⚠️  Transcript semi-anonymization helper"
  echo ""
  echo "Note: designlog transcripts are SUMMARIES of design decisions, not raw conversation."
  echo "They must be semi-anonymized before being committed to a project repo:"
  echo ""
  echo "  Speaker labels : use git user.name ($git_user)"
  echo "  Message content: anonymized — remove personal expressions and identifying info"
  echo ""
  echo "If you have raw session notes and want to convert them to a designlog transcript:"
  echo ""
  echo "1. Run 'designlog retrospective' to get a structured prompt for your agent"
  echo "2. The agent will generate a properly semi-anonymized summary transcript"
  echo ""
  echo "To review an existing transcript for identifying information in message content:"
  echo ""
  echo "Checklist:"
  echo "  ☐ Speaker labels use git user.name (not 'human' or 'user')"
  echo "  ☐ No personal expressions or anecdotes in message content"
  echo "  ☐ No email addresses or identifiers in message content"
  echo "  ☐ No personal preferences stated in first person"
  echo "  ☐ No user counts, revenue, or business-specific details that identify the company"
  echo "  ☐ Focuses on technical reasoning and decisions, not personal opinions"
  echo "  ☐ Follows the structured format (Session Overview, Decisions, Tradeoffs, etc.)"
  echo ""
  echo "Edit the file manually to remove any identifying information from message content:"
  echo "  $input_file"
  echo ""
  echo "Verify compliance with:"
  echo "  grep -E '(email|@|facebook|twitter|slack|company|revenue|users?)' $input_file"
}
