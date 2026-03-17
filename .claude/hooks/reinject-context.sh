#!/bin/bash
# Context Reinjection Hook
# Fires on: SessionStart (compact, resume), PostCompact
# Purpose: Reinject project state, architecture decisions, and current sprint
#          progress so Claude never loses track after context compression.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(cd "$SCRIPT_DIR/../.." && pwd)"
STATE_FILE="$PROJECT_DIR/.claude/sprint-state.json"

# Read sprint state
if [ ! -f "$STATE_FILE" ]; then
  echo "WARNING: Sprint state file not found at $STATE_FILE"
  exit 0
fi

CURRENT_SPRINT=$(jq -r '.currentSprint' "$STATE_FILE")
SPRINT_NAME=$(jq -r '.currentSprintName' "$STATE_FILE")
CURRENT_TASK=$(jq -r '.currentTask // "none"' "$STATE_FILE")
NOTES=$(jq -r '.notes // ""' "$STATE_FILE")
BLOCKERS=$(jq -r '.blockers | length' "$STATE_FILE")

# Get key decisions as bullet list
KEY_DECISIONS=$(jq -r '.keyDecisions[]' "$STATE_FILE" | sed 's/^/  - /')

# Get completed sprints summary
COMPLETED=$(jq -r '.completedSprints[] | "  - Sprint \(.sprint) (\(.name)): \(.summary)"' "$STATE_FILE")

# Get current sprint task statuses
TASK_STATUS=$(jq -r '.currentSprintTasks | to_entries[] | "  [\(.value.status)] \(.key): \(.value.name)"' "$STATE_FILE")

# Get recent git info
cd "$PROJECT_DIR"
BRANCH=$(git branch --show-current 2>/dev/null || echo "unknown")
LAST_COMMITS=$(git log --oneline -5 2>/dev/null || echo "  (no commits)")
MODIFIED_FILES=$(git diff --name-only 2>/dev/null | head -10)
UNTRACKED_FILES=$(git ls-files --others --exclude-standard 2>/dev/null | head -10)

# Build the context injection
cat <<CONTEXT
=== BOXING APP - CONTEXT REINJECTION (post-compaction) ===

## Current State
- Branch: $BRANCH
- Sprint: $CURRENT_SPRINT ($SPRINT_NAME)
- Current Task: $CURRENT_TASK
- Notes: $NOTES

## Key Architecture Decisions (DO NOT DEVIATE)
$KEY_DECISIONS

## Completed Sprints
$COMPLETED

## Current Sprint Tasks
$TASK_STATUS

## Recent Commits
$LAST_COMMITS

## Key Files to Reference
- Architecture: docs/FLUTTER_ARCHITECTURE.md (DEFINITIVE — read before writing code)
- Sprint plan: docs/sprints/SPRINT_PLAN.md
- Current sprint: docs/sprints/SPRINT_${CURRENT_SPRINT}_*.md
- Timer research: docs/TIMER_ENGINE_RESEARCH.md
- Audio research: docs/AUDIO_IMPLEMENTATION.md
- Models: lib/features/sessions/domain/session_model.dart
- Timer state: lib/features/timer/domain/timer_state.dart
- Presets: lib/core/constants/preset_sessions.dart
- Main: lib/main.dart
- Theme: lib/core/theme/app_theme.dart
- Router: lib/app/router.dart

## Project Structure
lib/
├── main.dart (Hive init, ProviderScope)
├── app/ (app.dart, router.dart)
├── core/ (constants/, theme/, utils/)
├── features/
│   ├── timer/ (data/, domain/, presentation/)
│   ├── sessions/ (data/, domain/, presentation/)
│   ├── audio/ (data/, domain/)
│   └── settings/ (data/, domain/, presentation/)
└── shared/widgets/

## Git Status
CONTEXT

if [ -n "$MODIFIED_FILES" ]; then
  echo "Modified files:"
  echo "$MODIFIED_FILES" | sed 's/^/  - /'
fi

if [ -n "$UNTRACKED_FILES" ]; then
  echo "Untracked files:"
  echo "$UNTRACKED_FILES" | sed 's/^/  - /'
fi

if [ "$BLOCKERS" -gt 0 ]; then
  echo ""
  echo "## BLOCKERS"
  jq -r '.blockers[]' "$STATE_FILE" | sed 's/^/  - /'
fi

cat <<INSTRUCTIONS

## Instructions
1. READ docs/FLUTTER_ARCHITECTURE.md before writing any code
2. READ the current sprint doc before starting tasks
3. Update .claude/sprint-state.json as you complete tasks
4. Run 'flutter analyze' and 'flutter test' before committing
5. Commit and push to branch: $BRANCH
6. Use 'export PATH="/opt/flutter/bin:\$PATH"' before flutter commands

=== END CONTEXT REINJECTION ===
INSTRUCTIONS
