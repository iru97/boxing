---
paths:
  - "lib/**/*.dart"
  - "test/**/*.dart"
---

# Dart/Flutter Code Style

- Follow the effective Dart style guide
- Use `const` constructors wherever possible
- Prefer `final` for variables that won't be reassigned
- Use 2-space indentation (Dart standard)
- Keep widgets under 100 lines; extract sub-widgets if larger
- Separate business logic from build methods
- Use trailing commas for better formatting and diffs
- Name files in snake_case, classes in PascalCase
- Group imports: dart, package, relative (separated by blank lines)
- Always dispose controllers, subscriptions, and timers in dispose()
