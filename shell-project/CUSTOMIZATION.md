# Shell Project Template Customization

This guide explains how to customize this template for your new shell script project.

## Quick Start

1. **Copy template** to your project directory
2. **Follow checklist** below
3. **Test workflows** with a test PR
4. **Start developing**

---

## Customization Checklist

### 1. Update Project Metadata

**File**: `README.md`

- [ ] Replace project title
- [ ] Update description
- [ ] Customize installation instructions
- [ ] Add your project-specific sections
- [ ] Update badge URLs (if using badges)

---

### 2. Add Your Shell Scripts

**Directory Structure**:

```
your-project/
├── bin/           # Executable scripts
├── lib/           # Library/helper scripts
├── tests/         # Test scripts
└── README.md
```

**Example Script**:

```bash
#!/bin/bash
# ABOUTME: Description of what this script does

set -euo pipefail

main() {
    echo "Hello from your script"
}

main "$@"
```

---

### 3. Customize Workflows (Optional)

All workflows use reusable workflows from [maxrantil/.github](https://github.com/maxrantil/.github).

**File**: `.github/workflows/shell-quality.yml`

If you need custom ShellCheck severity or paths:

```yaml
jobs:
  quality:
    uses: maxrantil/.github/.github/workflows/shell-quality-reusable.yml@master
    with:
      shellcheck-severity: 'error'           # Change severity: error, warning, info
      shellcheck-ignore-paths: 'tests/mocks' # Ignore specific paths
      shfmt-paths: 'bin/**/*.sh'             # Custom paths to format
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
  - repo: https://github.com/openstack/bashate
    rev: 2.1.1
    hooks:
      - id: bashate
        args: ['-i', 'E006']  # Ignore specific rules
```

---

### 5. ShellCheck Configuration (Optional)

**File**: `.shellcheckrc`

Create to customize ShellCheck behavior:

```bash
# Disable specific checks
disable=SC2034,SC2154

# Enable optional checks
enable=all

# Specify shell dialect
shell=bash
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

**Example**: Only run quality checks on specific branches

```yaml
# .github/workflows/shell-quality.yml
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
WORKFLOWS=("shell-quality.yml" "commit-format.yml" "verify-session-handoff.yml")

for workflow in "${WORKFLOWS[@]}"; do
  echo "Updating $workflow..."
  curl -s "$TEMPLATE_URL/shell-project/.github/workflows/$workflow" \
    > ".github/workflows/$workflow"
done

echo "✓ Workflows synced from template"
```

---

## Testing Your Customizations

### 1. Test Locally

```bash
# Run ShellCheck on all scripts
find . -name "*.sh" -exec shellcheck {} +

# Run shfmt to check formatting
shfmt -d -i 2 -ci .

# Fix formatting automatically
shfmt -w -i 2 -ci .

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
- [ ] Shell quality (ShellCheck + shfmt)
- [ ] CI (if tests present)
- [ ] Commit format
- [ ] Session handoff
- [ ] AI attribution blocking
- [ ] PR title check
- [ ] Pre-commit validation
- [ ] Protect master (branch protection)

---

## Common Customizations

### Add Specific Shell Dialect

**File**: `.github/workflows/shell-quality.yml`

```yaml
jobs:
  quality:
    uses: maxrantil/.github/.github/workflows/shell-quality-reusable.yml@master
    with:
      shellcheck-shell: 'bash'  # or 'sh', 'dash', 'ksh'
```

### Ignore Specific ShellCheck Rules

**File**: `.shellcheckrc` (create in project root)

```bash
# Disable specific checks globally
disable=SC2034  # Unused variable
disable=SC2154  # Variable referenced but not assigned
```

### Custom Formatting Style

**File**: `.editorconfig` (create in project root)

```ini
[*.sh]
indent_style = space
indent_size = 2
end_of_line = lf
insert_final_newline = true
trim_trailing_whitespace = true
```

---

## Troubleshooting

### Workflows failing after customization

1. Check workflow syntax: `yamllint .github/workflows/`
2. Verify input parameters match reusable workflow API
3. Check [workflow docs](https://github.com/maxrantil/.github#reusable-workflows)

### ShellCheck errors

```bash
# Check specific file with explanation
shellcheck -x your-script.sh

# List all available checks
shellcheck --list-optional

# Show description of specific check
shellcheck --wiki=SC2086
```

### Pre-commit hooks failing

```bash
# Update hooks
pre-commit autoupdate

# Run specific hook
pre-commit run shellcheck --all-files
```

### Formatting issues

```bash
# Check what shfmt would change (dry run)
shfmt -d .

# Apply formatting
shfmt -w .

# Use specific indent (e.g., 4 spaces)
shfmt -w -i 4 .
```

---

## Getting Help

- **Workflow issues**: See [.github repository](https://github.com/maxrantil/.github)
- **Template issues**: Open issue in [project-templates](https://github.com/maxrantil/project-templates)
- **ShellCheck**: Check [ShellCheck wiki](https://www.shellcheck.net/wiki/)
- **shfmt**: Check [shfmt documentation](https://github.com/mvdan/sh)

---

## Shell Script Best Practices

### Required Header

All scripts should start with:

```bash
#!/bin/bash
# ABOUTME: Clear description of script purpose

set -euo pipefail  # Exit on error, undefined vars, pipe failures
```

### Error Handling

```bash
# Trap errors and clean up
cleanup() {
    rm -f /tmp/tempfile
}
trap cleanup EXIT

# Check command success
if ! command -v git &> /dev/null; then
    echo "Error: git not found"
    exit 1
fi
```

### Documentation

```bash
# Add usage function
usage() {
    cat <<EOF
Usage: $0 [OPTIONS] ARGUMENTS

Description of what this script does.

OPTIONS:
    -h, --help     Show this help message
    -v, --verbose  Enable verbose output

EXAMPLES:
    $0 --verbose input.txt
EOF
}
```

---

**Template Version**: 2025-10-13
**Last Updated**: 2025-10-13
