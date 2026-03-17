---
name: analyze
description: Run flutter analyze, identify issues, and auto-fix lint errors and warnings.
argument-hint: "[path] or empty for whole project"
user-invocable: true
allowed-tools: Bash, Read, Edit, Grep, Glob
model: sonnet
context: inline
---

Run static analysis and fix issues.

## Steps

1. **Run analysis**:
   ```
   flutter analyze $ARGUMENTS
   ```

2. **If issues found**:
   - Read each file with issues
   - Fix lint errors and warnings (auto-fixable ones)
   - Apply `dart fix --apply` for automated fixes
   - Manually fix remaining issues

3. **Run analysis again** to verify all issues resolved

4. **Report**: List what was found and fixed, and any remaining issues that need human decision.

Do NOT fix issues that would change behavior (e.g., don't remove unused parameters from public APIs without confirmation). Focus on:
- Missing `const` constructors
- Unused imports
- Missing return types
- Prefer `final` over `var`
- Trailing commas
- Import ordering
