#!/bin/bash
# Stop Hook - Git & Sprint State Check
# Fires on: Stop
# Purpose: Remind about uncommitted changes and sprint state updates.

INPUT=$(cat)
STOP_HOOK_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false' 2>/dev/null || echo "false")

# Prevent infinite loop
if [ "$STOP_HOOK_ACTIVE" = "true" ]; then
  exit 0
fi

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"

cd "$PROJECT_DIR" || exit 0

MESSAGES=""

# Check for uncommitted changes (trim whitespace from wc output)
MODIFIED=$(git diff --name-only 2>/dev/null | wc -l | tr -d ' ')
STAGED=$(git diff --cached --name-only 2>/dev/null | wc -l | tr -d ' ')
UNTRACKED=$(git ls-files --others --exclude-standard 2>/dev/null | grep -v '.dart_tool' | grep -v '.pub/' | wc -l | tr -d ' ' || echo "0")

if [ "$MODIFIED" -gt 0 ] 2>/dev/null || [ "$STAGED" -gt 0 ] 2>/dev/null || [ "$UNTRACKED" -gt 0 ] 2>/dev/null; then
  MESSAGES="${MESSAGES}Git: ${MODIFIED} modified, ${STAGED} staged, ${UNTRACKED} untracked files. Consider committing and pushing."
fi

# Check if sprint state needs updating
STATE_FILE="$PROJECT_DIR/.claude/sprint-state.json"
if [ -f "$STATE_FILE" ]; then
  CURRENT_TASK=$(jq -r '.currentTask // "none"' "$STATE_FILE" 2>/dev/null || echo "none")
  if [ "$CURRENT_TASK" != "none" ] && [ "$CURRENT_TASK" != "null" ]; then
    if [ -n "$MESSAGES" ]; then
      MESSAGES="${MESSAGES}\n"
    fi
    MESSAGES="${MESSAGES}Sprint state: Task '${CURRENT_TASK}' is marked as in-progress. Update .claude/sprint-state.json if completed."
  fi
fi

if [ -n "$MESSAGES" ]; then
  printf '%b\n' "$MESSAGES"
fi

exit 0
