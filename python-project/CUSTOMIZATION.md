# Python Project Template Customization

This guide explains how to customize this template for your new Python project.

## Quick Start

1. **Copy template** to your project directory
2. **Follow checklist** below
3. **Test workflows** with a test PR
4. **Start developing**

---

## Customization Checklist

### 1. Update Project Metadata

**File**: `pyproject.toml`

```toml
[project]
name = "your-project-name"        # Change this
description = "Your description"  # Change this
authors = [
    {name = "Your Name", email = "you@example.com"}  # Change this
]
version = "0.1.0"
# ... rest stays same
```

---

### 2. Update README

**File**: `README.md`

- [ ] Replace project title
- [ ] Update description
- [ ] Customize installation instructions
- [ ] Add your project-specific sections
- [ ] Update badge URLs (if using badges)

---

### 3. Customize Workflows (Optional)

All workflows use reusable workflows from [maxrantil/.github](https://github.com/maxrantil/.github).

**File**: `.github/workflows/ci.yml`

If you need custom Python versions or test options:

```yaml
jobs:
  test:
    uses: maxrantil/.github/.github/workflows/python-test-reusable.yml@master
    with:
      python-version: '3.13'           # Change Python version
      working-directory: './src'        # If tests in subdirectory
      test-command: 'pytest -v tests/'  # Custom test command
```

See [workflow documentation](https://github.com/maxrantil/.github#reusable-workflows) for all options.

---

### 4. Pre-commit Configuration (Optional)

**File**: `.pre-commit-config.yaml`

Add project-specific hooks:

```yaml
repos:
  # ... existing hooks ...

  # Add project-specific hooks
  - repo: https://github.com/pycqa/pylint
    rev: v3.0.0
    hooks:
      - id: pylint
```

---

### 5. Dependencies

**Add dependencies**:
```bash
uv add requests httpx
```

**Add dev dependencies**:
```bash
uv add --dev mypy-extensions
```

**Update dependencies**:
```bash
uv sync
```

---

### 6. Remove Template Files

After customization, delete:
- [ ] `CUSTOMIZATION.md` (this file)
- [ ] `.github/workflows/README.md` (or keep as reference)

---

## Workflow Customization

### Disable Specific Workflows

If you don't need a workflow, delete the file:

```bash
# Example: Don't need AI attribution blocking
rm .github/workflows/block-ai-attribution.yml
```

### Change Workflow Triggers

**Example**: Only run CI on specific branches

```yaml
# .github/workflows/ci.yml
on:
  pull_request:
    branches:
      - master      # Only run on PRs to master
      - develop     # and develop
```

---

## Syncing Template Updates

Template improvements are made in [project-templates](https://github.com/maxrantil/project-templates).

**To sync updates**:

1. Check template repository for changes
2. Compare your workflows with template workflows
3. Update manually (or use script below)

**Automation** (advanced):

```bash
#!/bin/bash
# sync-template.sh - Sync workflow updates from template

TEMPLATE_URL="https://raw.githubusercontent.com/maxrantil/project-templates/master"
WORKFLOWS=("ci.yml" "commit-format.yml" "verify-session-handoff.yml")

for workflow in "${WORKFLOWS[@]}"; do
  echo "Updating $workflow..."
  curl -s "$TEMPLATE_URL/python-project/.github/workflows/$workflow" \
    > ".github/workflows/$workflow"
done

echo "✓ Workflows synced from template"
```

---

## Testing Your Customizations

### 1. Test Locally

```bash
# Install dependencies
uv sync

# Run tests
uv run pytest

# Run pre-commit
pre-commit run --all-files
```

### 2. Test Workflows

Create a test PR:

```bash
git checkout -b test-workflows
git commit --allow-empty -m "test: trigger workflows"
git push -u origin test-workflows
gh pr create --title "test: validate workflows"
```

Check all workflows pass:
- [ ] CI (pytest, ruff, mypy)
- [ ] Commit format
- [ ] Session handoff
- [ ] AI attribution blocking
- [ ] PR title check
- [ ] Pre-commit validation

---

## Common Customizations

### Add More Python Versions

**File**: `.github/workflows/ci.yml`

```yaml
jobs:
  test:
    strategy:
      matrix:
        python-version: ['3.11', '3.12', '3.13']
    uses: maxrantil/.github/.github/workflows/python-test-reusable.yml@master
    with:
      python-version: ${{ matrix.python-version }}
```

### Custom Test Command

```yaml
jobs:
  test:
    uses: maxrantil/.github/.github/workflows/python-test-reusable.yml@master
    with:
      test-command: 'pytest tests/ --cov=myproject --cov-report=xml'
```

### Add Code Coverage

```bash
# Install coverage
uv add --dev pytest-cov

# Update test command in CI
test-command: 'pytest --cov --cov-report=term'
```

---

## Troubleshooting

### Workflows failing after customization

1. Check workflow syntax: `yamllint .github/workflows/`
2. Verify input parameters match reusable workflow API
3. Check [workflow docs](https://github.com/maxrantil/.github#reusable-workflows)

### Pre-commit hooks failing

```bash
# Update hooks
pre-commit autoupdate

# Run specific hook
pre-commit run ruff --all-files
```

### Dependencies not installing

```bash
# Clear cache and reinstall
rm -rf .venv/
uv sync
```

---

## Getting Help

- **Workflow issues**: See [.github repository](https://github.com/maxrantil/.github)
- **Template issues**: Open issue in [project-templates](https://github.com/maxrantil/project-templates)
- **Python/UV issues**: Check [UV docs](https://github.com/astral-sh/uv)

---

**Template Version**: 2025-10-13
**Last Updated**: 2025-10-13
