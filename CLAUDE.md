# Boxing - Training Timer App

## Project Overview
A Flutter mobile app for boxing training round management. The core feature is a reliable, boxing-specific session timer with configurable rounds, rest periods, warnings, and authentic audio cues.

See @docs/VISION.md for full project vision, competitive analysis, and roadmap.

## Quick References
- @docs/VISION.md - Project vision and competitive landscape
- @.claude/CLAUDE.md - Claude Code configuration and standards
- @.claude/rules/ - Path-specific coding rules
- @pubspec.yaml - Flutter dependencies (when available)

## Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod or Bloc
- **Audio**: `just_audio` + `audio_service` (background playback)
- **Wake Lock**: `wakelock_plus`
- **Storage**: Hive or SharedPreferences
- **Target**: Android + iOS

## Architecture Principles
- Timer logic must be independent of UI (testable, background-safe)
- Audio playback must work with screen locked and over other apps' music
- Session configuration is the central data model
- Preset sessions are immutable; user sessions are persisted locally
- Minimize permissions: audio, foreground service, wake lock only

## Development Workflow
- Branch naming: `feature/`, `fix/`, `chore/` prefixes
- Commit messages: imperative mood, concise
- Run `flutter analyze` before committing
- Run `flutter test` before pushing
- Use the planner agent before complex features
- Use the code-reviewer agent after implementations

## Model Configuration
- Default: Opus 4.6 for architecture decisions and complex logic
- Sonnet for UI components, simple edits, and quick tasks
- Haiku for status checks and simple queries
