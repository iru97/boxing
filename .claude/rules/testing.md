---
paths:
  - "test/**/*.dart"
  - "**/*_test.dart"
---

# Flutter Testing Rules

- Name test files: `<source_file>_test.dart` in matching directory structure
- Use descriptive test names: `'should fire warning sound 10 seconds before round end'`
- Follow Arrange-Act-Assert pattern
- Mock external services (audio, storage, platform channels)
- Never mock the timer engine itself in timer tests - test real behavior
- Test timer accuracy: verify elapsed time within acceptable tolerance (±50ms)
- Test state transitions: warmup -> work -> warning -> rest -> work -> ... -> complete
- Test edge cases: pause during warning, skip round, restart session
- Keep tests independent; no shared mutable state
- Use `flutter test` to run, `flutter test --coverage` for coverage reports
