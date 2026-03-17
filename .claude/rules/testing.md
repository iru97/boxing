---
paths:
  - "**/*.test.*"
  - "**/*.spec.*"
  - "tests/**/*"
  - "test/**/*"
---

# Testing Rules

- Name test files with `.test.` or `.spec.` suffix matching the source file
- Use descriptive test names that explain the expected behavior
- Follow Arrange-Act-Assert pattern
- Test both happy path and error cases
- Mock external dependencies, not internal logic
- Keep tests independent; no shared mutable state between tests
