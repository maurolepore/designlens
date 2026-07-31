#!/bin/bash
# Run Python tests for designlens. Skips gracefully if pytest is not installed.

cd "$(dirname "$0")/.." || exit 1

if ! command -v pytest >/dev/null 2>&1; then
  echo ""
  echo "# Python tests skipped — pytest not installed"
  echo ""
  exit 0
fi

pytest tests/tools_designlens_get_session_stats_test.py -v
