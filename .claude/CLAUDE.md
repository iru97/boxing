# Claude Code Project Configuration

## Architecture & Standards

### General Principles
- Keep files focused and single-responsibility
- Use descriptive naming for files, functions, and variables
- Document complex logic with inline comments only when not self-evident
- Avoid over-engineering; solve for current requirements

### Error Handling
- Handle errors at system boundaries (user input, external APIs)
- Use meaningful error messages
- Never swallow errors silently

### Security
- Never commit secrets, API keys, or credentials
- Validate all external input
- Follow OWASP top 10 guidelines

## Agent & Skill Usage

### Available Agents
- **code-reviewer**: Post-implementation code quality review
- **planner**: Architecture and implementation planning
- **debugger**: Bug investigation and resolution
- **researcher**: Codebase exploration and documentation

### Available Skills
- `/review` - Run a code review on recent changes
- `/plan` - Create an implementation plan
- `/status` - Show project status and health

## Team Orchestration
- Agents can work in parallel using worktree isolation
- Use the planner agent before starting complex multi-file changes
- Use the code-reviewer agent after completing implementations
- Max team size: 5 concurrent agents

## References
- @../CLAUDE.md - Root project instructions
- @rules/ - Path-specific rules
