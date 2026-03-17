#!/bin/bash
# Stop Hook - Git & Sprint State Check
# Fires on: Stop
# Purpose: Remind about uncommitted changes and sprint state updates.

set -euo pipefail

INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')

# Prevent infinite loop
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_DIR"

MESSAGES=""

# Check for uncommitted changes
MODIFIED=$(git diff --name-only 2>/dev/null | wc -l)
STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l)
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '.dart_tool' | grep -v '.pub/' | wc -l)

if [ "$MODIFIED" -gt 0 ] || [ "$STAGED" -gt 0 ] || [ "$UNTRACKED" -gt 0 ]; then
  MESSAGES="$MESSAGES\nGit: ${MODIFIED} modified, ${STAGED} staged, ${UNTRACKED} untracked files. Consider committing and pushing."
fi

# Check if sprint state needs updating
STATE_FILE="$PROJECT_DIR/.claude/sprint-state.json"
if [ -f "$STATE_FILE" ]; then
  CURRENT_TASK=$(jq -r '.currentTask // "none"' "$STATE_FILE")
  if [ "$CURRENT_TASK" != "none" ] && [ "$CURRENT_TASK" != "null" ]; then
    MESSAGES="$MESSAGES\nSprint state: Task '$CURRENT_TASK' is marked as in-progress. Update .claude/sprint-state.json if completed."
  fi
fi

if [ -n "$MESSAGES" ]; then
  echo -e "$MESSAGES"
fi

exit 0
