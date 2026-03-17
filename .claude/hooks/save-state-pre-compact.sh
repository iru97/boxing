#!/bin/bash
# Pre-Compaction State Save Hook
# Fires on: PreCompact
# Purpose: Ensure sprint state and any uncommitted progress is captured
#          before context gets compressed.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_FILE="$PROJECT_DIR/.claude/sprint-state.json"

cd "$PROJECT_DIR"

# Update the state file timestamp
if [ -f "$STATE_FILE" ]; then
  TEMP=$(mktemp)
  jq --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" '.lastCompactionAt = $ts' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
fi

echo "State saved before context compaction at $(date -u +%H:%M:%S)"
