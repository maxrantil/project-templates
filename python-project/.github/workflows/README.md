# GitHub Actions Workflows Documentation

This directory contains automated workflows that enforce project standards and quality requirements.

## Workflow Overview

### Pull Request Workflows (Run on every PR to master)

| Workflow | Purpose | Blocks PR? | Runtime |
|----------|---------|------------|---------|
| `pr-title-check.yml` | Validates PR title follows conventional commit format | ✅ Yes | ~5s |
| `commit-format.yml` | Validates all commits follow conventional format | ✅ Yes | ~10s |
| `block-ai-attribution.yml` | Detects AI/agent attribution in commits | ✅ Yes | ~10s |
| `verify-session-handoff.yml` | Ensures session handoff documentation exists | ✅ Yes | ~8s |
| `ci.yml` | Executes full test suite (pytest) | ✅ Yes | ~2min |
| `pre-commit-validation.yml` | Runs all pre-commit hooks | ✅ Yes | ~45s |

### Push Workflows (Run on pushes to master)

| Workflow | Purpose | Blocks Push? | Runtime |
|----------|---------|--------------|---------|
| `protect-master.yml` | Blocks direct pushes to master (only allows PR merges) | ✅ Yes | ~5s |

## Conventional Commit Format

All commits and PR titles must follow the conventional commit format:

```
type(scope): description
```

### Valid Types:
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Test additions or changes
- `chore`: Maintenance tasks
- `perf`: Performance improvements
- `ci`: CI/CD changes
- `build`: Build system changes
- `revert`: Revert previous commit

### Scope (Optional):
- Lowercase letters, numbers, dashes, underscores only
- Examples: `(api)`, `(auth)`, `(config)`

### Breaking Changes:
- Add `!` before colon: `feat(api)!: breaking change`

### Examples:
```
✅ feat(api): add new endpoint
✅ fix(auth): resolve token expiration
✅ docs: update installation guide
✅ refactor!: breaking change to API
❌ Add feature (missing type)
❌ feat : extra space (invalid format)
❌ FEAT: uppercase type (must be lowercase)
```

## Session Handoff Requirements

Per CLAUDE.md Section 5, every PR must include session handoff documentation.

### Required Formats:

**Option A: Living Document (Recommended)**
- File: `SESSION_HANDOVER.md` (project root)
- Update this file with each PR

**Option B: Dated Documents**
- File: `docs/implementation/SESSION-HANDOFF-[issue]-[date].md`
- Create new file per issue

### Required Sections:
1. Completed Work summary
2. Current Project State
3. Agent Validation Status
4. Next Session Priorities
5. Startup Prompt for next session

## AI Attribution Policy

Per CLAUDE.md, AI/agent attribution must NOT appear in:
- ❌ Commit messages
- ❌ PR titles/descriptions

### Blocked Patterns:
- `Co-authored-by: Claude <...>`
- `Generated with Claude Code`
- `Reviewed by [agent-name] agent`
- References to `claude.com/claude-code`

### Where Agent Work SHOULD Be Documented:
- ✅ Session handoff files
- ✅ Implementation documentation
- ✅ PRD/PDR documents
- ✅ Internal design docs

### Human Co-authors ARE Welcome:
```
✅ Co-authored-by: John Doe <john@example.com>
✅ Co-authored-by: Jane Smith <jane@company.com>
```

## Testing Workflows Locally

Before pushing changes, test workflows locally:

### 1. Test Pre-commit Hooks:
```bash
pre-commit install
pre-commit run --all-files
```

### 2. Test Python Code:
```bash
pytest --cov
```

### 3. Test Commit Format:
```bash
# Your commit messages should follow: type(scope): description
git commit -m "feat(api): add new endpoint"
```

## Debugging Workflow Failures

### View Workflow Logs:
1. Go to PR on GitHub
2. Click "Checks" tab
3. Click failed workflow
4. Expand failed step to see logs

### Common Failure Reasons:

**PR Title Check Failed:**
- Fix: Rename PR to follow format: `type(scope): description`
- Example: `feat(api): add new endpoint`

**Commit Format Failed:**
- Fix: Amend commit message: `git commit --amend`
- Then force push: `git push --force`

**AI Attribution Detected:**
- Fix: Remove attribution from commit messages
- Use: `git rebase -i master` to edit commits

**Session Handoff Missing:**
- Fix: Create/update `SESSION_HANDOVER.md`
- Include all required sections (see above)

**Tests Failed:**
- Fix: Run tests locally: `pytest`
- Identify failing test
- Fix code to pass test
- Commit fix and push

## Best Practices

### For Contributors:
1. **Test locally first** (saves time vs waiting for CI)
2. **Use conventional commits** from the start (avoid amending)
3. **Create session handoff early** (don't wait until PR time)
4. **Address workflow failures promptly** (don't let them accumulate)

### For Maintainers:
1. **Keep workflows fast** (< 5 minutes total preferred)
2. **Provide helpful error messages** (include examples)
3. **Document policy changes** (update this README)

## Additional Resources

- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Project Guidelines: CLAUDE.md](../../CLAUDE.md)
