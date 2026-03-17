---
name: status
description: Show project status including git state, recent changes, and health checks.
user-invocable: true
allowed-tools: Bash, Read, Glob, Grep
model: haiku
context: inline
---

Show the current project status by running these checks:

1. **Git Status**: Run `git status` to show current branch, staged/unstaged changes, and untracked files
2. **Recent Commits**: Run `git log --oneline -10` to show the last 10 commits
3. **Branch Info**: Run `git branch -vv` to show branches and tracking info
4. **File Count**: Count the number of source files in the project
5. **TODO/FIXME**: Search for any TODO or FIXME comments in the codebase

Present the results in a clean, organized format.
