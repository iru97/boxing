#!/bin/bash
# Sprint State Updater
# Usage:
#   ./update-sprint-state.sh task-complete <task_id>
#   ./update-sprint-state.sh task-start <task_id>
#   ./update-sprint-state.sh sprint-complete
#   ./update-sprint-state.sh set-note "some note"
#   ./update-sprint-state.sh add-blocker "description"

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_FILE="$PROJECT_DIR/.claude/sprint-state.json"

if [ ! -f "$STATE_FILE" ]; then
  echo "Error: State file not found at $STATE_FILE" >&2
  exit 1
fi

ACTION="${1:-help}"
ARG="${2:-}"
TEMP=$(mktemp)

case "$ACTION" in
  task-complete)
    if [ -z "$ARG" ]; then echo "Usage: $0 task-complete <task_id>" >&2; exit 1; fi
    jq --arg id "$ARG" '.currentSprintTasks[$id].status = "completed"' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
    # Clear current task if it matches
    CURRENT=$(jq -r '.currentTask // ""' "$STATE_FILE")
    if [ "$CURRENT" = "$ARG" ]; then
      jq '.currentTask = null' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
    fi
    echo "Task $ARG marked as completed"
    ;;

  task-start)
    if [ -z "$ARG" ]; then echo "Usage: $0 task-start <task_id>" >&2; exit 1; fi
    jq --arg id "$ARG" '.currentSprintTasks[$id].status = "in_progress" | .currentTask = $id' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
    echo "Task $ARG marked as in_progress"
    ;;

  sprint-complete)
    SPRINT=$(jq -r '.currentSprint' "$STATE_FILE")
    NAME=$(jq -r '.currentSprintName' "$STATE_FILE")
    SUMMARY="${ARG:-Sprint $SPRINT completed}"
    NEXT=$((SPRINT + 1))

    jq --arg summary "$SUMMARY" --arg date "$(date +%Y-%m-%d)" --argjson next "$NEXT" '
      .completedSprints += [{
        sprint: .currentSprint,
        name: .currentSprintName,
        completedAt: $date,
        summary: $summary
      }] |
      .currentSprint = $next |
      .currentSprintTasks = {} |
      .currentTask = null |
      .notes = ""
    ' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
    echo "Sprint $SPRINT ($NAME) completed. Now on Sprint $NEXT."
    ;;

  set-note)
    if [ -z "$ARG" ]; then echo "Usage: $0 set-note \"note text\"" >&2; exit 1; fi
    jq --arg note "$ARG" '.notes = $note' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
    echo "Note updated"
    ;;

  add-blocker)
    if [ -z "$ARG" ]; then echo "Usage: $0 add-blocker \"description\"" >&2; exit 1; fi
    jq --arg b "$ARG" '.blockers += [$b]' "$STATE_FILE" > "$TEMP" && mv "$TEMP" "$STATE_FILE"
    echo "Blocker added"
    ;;

  show)
    jq '.' "$STATE_FILE"
    ;;

  help|*)
    echo "Usage: $0 <action> [arg]"
    echo "Actions: task-complete, task-start, sprint-complete, set-note, add-blocker, show"
    ;;
esac
