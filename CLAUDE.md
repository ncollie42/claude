# CLAUDE.md - AI Assistant Guide

**Repository**: ncollie42/claude
**Last Updated**: 2025-11-23

This document provides comprehensive guidance for AI assistants (like Claude) working on this codebase. It covers architecture, conventions, workflows, and best practices.

---

## Table of Contents

1. [Repository Overview](#repository-overview)
2. [Codebase Structure](#codebase-structure)
3. [Development Workflow](#development-workflow)
4. [Code Conventions](#code-conventions)
5. [Testing Strategy](#testing-strategy)
6. [Git Practices](#git-practices)
7. [AI Assistant Guidelines](#ai-assistant-guidelines)
8. [Common Tasks](#common-tasks)
9. [Troubleshooting](#troubleshooting)

---

## Repository Overview

### Purpose
*[To be filled as the project develops]*

This repository is currently being initialized. The purpose and scope will be documented here as development progresses.

### Tech Stack
*[To be filled as technologies are adopted]*

- **Language**: TBD
- **Framework**: TBD
- **Build Tool**: TBD
- **Package Manager**: TBD
- **Testing**: TBD

### Key Dependencies
*[To be updated as dependencies are added]*

```
[List major dependencies here]
```

---

## Codebase Structure

### Directory Layout

```
/
├── src/           # Source code (when added)
├── tests/         # Test files (when added)
├── docs/          # Documentation (when added)
├── scripts/       # Build and utility scripts (when added)
├── config/        # Configuration files (when added)
└── CLAUDE.md      # This file
```

### Module Organization

*[Document module structure as the codebase grows]*

#### Core Modules
- **[Module Name]**: [Description]

#### Utility Modules
- **[Module Name]**: [Description]

### Architecture Patterns

*[Document architectural decisions as they are made]*

---

## Development Workflow

### Setting Up Development Environment

```bash
# Clone the repository
git clone <repository-url>
cd claude

# [Add setup steps as the project develops]
# Install dependencies
# Set up environment variables
# Run initial builds
```

### Branch Strategy

This repository uses a **feature branch workflow**:

- **Main Branch**: `main` or `master` (to be determined)
- **Feature Branches**: `claude/[descriptive-name]-[session-id]`
- **Development Branches**: Follow the pattern specified in task context

#### Branch Naming Convention

```
claude/[feature-description]-[unique-session-id]
```

Example: `claude/add-authentication-01JwZ8ytz8T848HUTUhjuS9d`

### Development Cycle

1. **Create Feature Branch**
   ```bash
   git checkout -b claude/[feature-name]-[session-id]
   ```

2. **Develop & Commit**
   ```bash
   # Make changes
   git add .
   git commit -m "Clear, descriptive message"
   ```

3. **Push to Remote**
   ```bash
   git push -u origin claude/[feature-name]-[session-id]
   ```

4. **Create Pull Request**
   ```bash
   # Use gh CLI or web interface
   gh pr create --title "Feature: [description]" --body "[details]"
   ```

---

## Code Conventions

### General Principles

1. **Simplicity First**: Avoid over-engineering. Implement only what's needed.
2. **Readability**: Code should be self-documenting. Use clear names and simple logic.
3. **Consistency**: Follow existing patterns in the codebase.
4. **No Premature Optimization**: Optimize only when there's a proven need.

### Naming Conventions

*[To be established based on language/framework choice]*

- **Files**: TBD
- **Functions/Methods**: TBD
- **Variables**: TBD
- **Constants**: TBD
- **Classes**: TBD

### Code Style

*[To be established - may include links to style guides]*

- **Indentation**: TBD
- **Line Length**: TBD
- **Comments**: Only where logic isn't self-evident
- **Documentation**: TBD

### Error Handling

- Validate at system boundaries (user input, external APIs)
- Trust internal code and framework guarantees
- Don't add error handling for scenarios that can't happen

### Security Considerations

**Always be vigilant for**:
- Command injection vulnerabilities
- Cross-Site Scripting (XSS)
- SQL injection
- Insecure authentication/authorization
- Exposure of secrets or sensitive data
- Other OWASP Top 10 vulnerabilities

**Security Checklist**:
- ✅ Never commit secrets, API keys, or credentials
- ✅ Validate and sanitize all external input
- ✅ Use parameterized queries for databases
- ✅ Implement proper authentication and authorization
- ✅ Keep dependencies updated

---

## Testing Strategy

### Testing Levels

*[To be established as testing infrastructure is added]*

- **Unit Tests**: TBD
- **Integration Tests**: TBD
- **End-to-End Tests**: TBD

### Running Tests

```bash
# [Add test commands as testing is set up]
```

### Test Coverage

*[Document coverage requirements and current status]*

---

## Git Practices

### Commit Messages

Follow conventional commit format:

```
<type>: <description>

[optional body]

[optional footer]
```

**Types**:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks
- `perf`: Performance improvements

**Examples**:
```
feat: add user authentication module

fix: resolve null pointer in data parser

docs: update API documentation for v2
```

### Commit Best Practices

- **Focus on the "why"**, not the "what"
- Keep commits atomic and focused
- Don't commit files with secrets (.env, credentials.json, etc.)
- Run tests before committing (when applicable)

### Git Operations with Network Retry

**For git push**:
- Always use `git push -u origin <branch-name>`
- Branch must start with `claude/` and end with matching session ID
- Retry up to 4 times with exponential backoff (2s, 4s, 8s, 16s) on network errors

**For git fetch/pull**:
- Prefer fetching specific branches: `git fetch origin <branch-name>`
- Retry up to 4 times with exponential backoff on network failures

### Pre-commit Hooks

*[Document any pre-commit hooks as they are added]*

If commit fails due to pre-commit hook:
1. Review the changes made by the hook
2. If safe and files were modified, amend the commit
3. Otherwise, create a new commit

---

## AI Assistant Guidelines

### Core Principles

1. **Read Before Writing**: Always read existing files before modifying them
2. **Use Existing Patterns**: Follow established conventions in the codebase
3. **Minimal Changes**: Only change what's necessary for the task
4. **No Speculation**: Don't propose changes to code you haven't read

### Tool Usage

**Preferred Tools**:
- Use `Read` for reading files (not `cat`)
- Use `Edit` for modifying files (not `sed`/`awk`)
- Use `Write` for new files (not `echo >` or heredocs)
- Use `Glob` for finding files by pattern (not `find`)
- Use `Grep` for searching code (not `grep` command)

**Task Planning**:
- Use `TodoWrite` for complex multi-step tasks
- Break down large tasks into smaller, manageable steps
- Mark tasks as in_progress before starting
- Mark tasks as completed immediately after finishing

### Code Changes

**DO**:
- ✅ Read files before editing
- ✅ Follow existing code style and patterns
- ✅ Write clear, simple code
- ✅ Add comments only where logic isn't self-evident
- ✅ Test changes when possible
- ✅ Fix security vulnerabilities immediately

**DON'T**:
- ❌ Over-engineer solutions
- ❌ Add unnecessary features
- ❌ Create premature abstractions
- ❌ Add docstrings to unchanged code
- ❌ Use backwards-compatibility hacks for new code
- ❌ Add error handling for impossible scenarios

### Communication

- Be concise and clear
- Use markdown for formatting
- Output text directly (not via bash echo)
- Avoid emojis unless requested
- Focus on technical accuracy over validation

### File References

When referencing code, use the format:
```
file_path:line_number
```

Example: `src/services/auth.ts:42`

---

## Common Tasks

### Adding a New Feature

1. **Plan the feature**
   - Use TodoWrite to create a task list
   - Break down into specific, actionable steps

2. **Research existing code**
   - Search for similar implementations
   - Understand existing patterns and conventions

3. **Implement**
   - Create or modify necessary files
   - Follow code conventions
   - Keep changes minimal and focused

4. **Test**
   - Write tests if testing infrastructure exists
   - Manually verify functionality

5. **Commit and Push**
   - Write clear commit message
   - Push to feature branch
   - Create PR if ready

### Fixing a Bug

1. **Understand the bug**
   - Read relevant code
   - Identify root cause

2. **Fix the issue**
   - Make minimal changes
   - Don't refactor surrounding code

3. **Verify the fix**
   - Test the specific scenario
   - Check for regressions

4. **Commit**
   - Use `fix:` prefix
   - Explain the root cause in commit message

### Refactoring Code

1. **Justify the refactoring**
   - Only refactor when explicitly requested
   - Or when required for new functionality

2. **Plan the changes**
   - Identify scope
   - Consider impacts

3. **Make incremental changes**
   - Small, logical commits
   - Maintain functionality throughout

4. **Test thoroughly**
   - Ensure no behavioral changes
   - Verify all use cases

---

## Troubleshooting

### Common Issues

#### Empty Repository
**Symptom**: No files in repository except .git
**Solution**: Start by creating initial project structure and documentation

#### Git Push Fails with 403
**Symptom**: HTTP 403 error when pushing
**Solution**: Ensure branch name starts with `claude/` and ends with session ID

#### Pre-commit Hook Failures
**Symptom**: Commit rejected by pre-commit hook
**Solution**: Review hook changes, fix issues, then retry commit

#### Network Errors During Git Operations
**Symptom**: Timeout or connection errors
**Solution**: Retry with exponential backoff (2s, 4s, 8s, 16s)

### Getting Help

*[Add resources and contact information as needed]*

- Check existing documentation in `/docs`
- Review similar implementations in codebase
- Consult external documentation for frameworks/libraries
- Ask for clarification when requirements are ambiguous

---

## Maintenance

### Updating This Document

This document should be updated:
- When major architectural decisions are made
- When new conventions are established
- When development workflow changes
- When new tools or frameworks are adopted
- When common issues and solutions are identified

### Document History

- **2025-11-23**: Initial creation for new repository

---

## Quick Reference

### Essential Commands

```bash
# Development
git checkout -b claude/[feature]-[session-id]
git add .
git commit -m "type: description"
git push -u origin <branch-name>

# [Add project-specific commands as they become available]
# Build: TBD
# Test: TBD
# Lint: TBD
# Format: TBD
```

### File Locations

*[To be updated as project structure develops]*

```
Configuration: TBD
Tests: TBD
Documentation: TBD
Entry Point: TBD
```

---

## Notes for Future Development

This CLAUDE.md file is a living document that should evolve with the codebase. As the project develops:

1. **Update the Tech Stack section** with actual technologies used
2. **Document the directory structure** as it's created
3. **Add specific code conventions** based on language/framework choices
4. **Include testing commands** once testing infrastructure is in place
5. **Document build and deployment processes** as they're established
6. **Add troubleshooting entries** based on actual issues encountered
7. **Include examples** of good code patterns from the codebase
8. **Document APIs and interfaces** as they're created

---

*This document is maintained by AI assistants working on the codebase and should be kept up-to-date with the current state of the project.*
