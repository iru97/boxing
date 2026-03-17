---
name: test
description: Generate and run Flutter tests for a specific file, feature, or the entire project.
argument-hint: "[file-or-feature] or 'all'"
user-invocable: true
allowed-tools: Read, Grep, Glob, Write, Edit, Bash
model: sonnet
context: fork
agent: test-writer
---

Generate and/or run tests for: $ARGUMENTS

## Behavior

**If a specific file is given** (e.g., `lib/services/timer_engine.dart`):
1. Read the source file
2. Check if a test already exists in the mirror `test/` path
3. If no test exists, create one with comprehensive coverage
4. If test exists, check for missing coverage and add tests
5. Run the test: `flutter test <test_file>`

**If a feature name is given** (e.g., `timer`):
1. Find all source files in `lib/features/<feature>/`
2. Check for existing tests
3. Create missing tests
4. Run all feature tests: `flutter test test/unit/providers/<feature>* test/widget/features/<feature>*`

**If `all` is given**:
1. Run `flutter test` for the entire project
2. Report results: passes, failures, and coverage gaps
3. Suggest missing tests for untested files

Always follow the project testing rules in `.claude/rules/testing.md`.
