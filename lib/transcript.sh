#!/bin/bash

# Normalize a transcript to the standard format
# Converts various transcript formats to the standard human:/assistant: markdown

spec_transcript() {
  local input_file="$1"
  local output_file="${input_file%.md}.normalized.md"

  if [ ! -f "$input_file" ]; then
    echo "Error: File not found: $input_file"
    exit 1
  fi

  echo "Normalizing transcript: $input_file"
  echo "Output: $output_file"
  echo ""
  echo "⚠️  Manual review required."
  echo ""
  echo "The transcript.sh tool can assist with reformatting, but normalizing"
  echo "transcripts from different tools requires understanding the source format."
  echo ""
  echo "Standard speclog transcript format:"
  echo ""
  echo "## Turn 1"
  echo "**human:** ..."
  echo ""
  echo "## Turn 2"
  echo "**assistant:** ..."
  echo ""
  echo "---"
  echo ""
  echo "Steps to normalize:"
  echo "  1. Review $input_file"
  echo "  2. Convert to the format above (Turn N, human:/assistant: labels)"
  echo "  3. Save to $latest_stage/.transcript.md"
  echo "  4. Verify with: cat $latest_stage/.transcript.md"
  echo ""
  echo "If you're converting from Claude API JSON output, consider using:"
  echo "  https://github.com/[org]/speclog/tools/json-to-transcript.py"
}
