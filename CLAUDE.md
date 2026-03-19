# Boxing - Smart Training Companion

## Project Overview
A Flutter mobile app that started as a boxing training timer and is evolving into a smart training companion for combat sports. V1 (complete) delivers a reliable, background-safe timer. V2 adds training intelligence: combo callouts, sport-specific drill structures, and guided workout programs.

> "The timer is free. The brain is paid."

See @docs/VISION.md for full project vision, V2 direction, and roadmap.

## Quick References
- @docs/VISION.md - Project vision, V1 summary, V2 direction
- @docs/research/ - V2 research framework (7 documents, 6,893 lines)
- @docs/REFERENCES.md - Flutter repos, packages, competitor apps, user quotes
- @docs/sprints/SPRINT_PLAN.md - V1 sprint plan (all complete)
- @.claude/CLAUDE.md - Claude Code configuration and standards
- @.claude/rules/ - Path-specific coding rules
- @pubspec.yaml - Flutter dependencies

## Tech Stack
- **Framework**: Flutter (Dart)
- **State Management**: Riverpod
- **Audio**: `just_audio` + `audio_service` (background playback) + `flutter_tts` (voice)
- **Wake Lock**: `wakelock_plus`
- **Storage**: Hive
- **Routing**: GoRouter
- **Models**: Freezed (immutable data classes)
- **Target**: Android + iOS

## Architecture Principles
- Timer logic must be independent of UI (testable, background-safe)
- Audio playback must work with screen locked and over other apps' music
- Session configuration is the central data model
- Preset sessions are immutable; user sessions are persisted locally
- Minimize permissions: audio, foreground service, wake lock only
- V2: Combo/training data is separate from timer data (composable layers)

## Development Workflow
- Branch naming: `feature/`, `fix/`, `chore/` prefixes
- Commit messages: imperative mood, concise
- Run `flutter analyze` before committing
- Run `flutter test` before pushing
- Use the planner agent before complex features
- Use the code-reviewer agent after implementations

## Current Status
- **V1**: Complete (all 7 sprints done) — reliable timer, background, audio ducking, compound rounds, voice TTS, i18n
- **V2**: Planning phase — combo callouts, sport-specific training, guided programs
- **Deferred**: Coach mode (needs dedicated research phase)

## Model Configuration
- Default: Opus 4.6 for architecture decisions and complex logic
- Sonnet for UI components, simple edits, and quick tasks
- Haiku for status checks and simple queries
