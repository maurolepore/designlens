#!/bin/bash

# Helper for creating decision transcript summaries
# Guides depersonalization and anonymization of session notes

spec_transcript() {
  local input_file="$1"

  if [ ! -f "$input_file" ]; then
    echo "Error: File not found: $input_file"
    exit 1
  fi

  echo "⚠️  Transcript summary depersonalization helper"
  echo ""
  echo "Note: designlog transcripts are SUMMARIES of design decisions, not raw conversation."
  echo "They must be carefully anonymized before being committed to a project repo."
  echo ""
  echo "If you have raw session notes and want to convert them to a designlog transcript:"
  echo ""
  echo "1. Run 'designlog retrospective' to get a structured prompt for your agent"
  echo "2. The agent will generate a properly anonymized summary transcript"
  echo ""
  echo "To review an existing transcript for PII:"
  echo ""
  echo "Checklist:"
  echo "  ☐ No personal names mentioned"
  echo "  ☐ No email addresses or identifiers"
  echo "  ☐ No personal anecdotes or preferences"
  echo "  ☐ Uses passive voice or role-based language"
  echo "  ☐ No user counts, revenue, or business-specific details that identify the company"
  echo "  ☐ Focuses on technical reasoning and decisions, not the people"
  echo "  ☐ Follows the structured format (Session Overview, Decisions, Tradeoffs, etc.)"
  echo ""
  echo "Edit the file manually to remove any identifying information:"
  echo "  $input_file"
  echo ""
  echo "Verify compliance with:"
  echo "  grep -E '(email|@|facebook|twitter|slack|company|revenue|users?)' $input_file"
}
