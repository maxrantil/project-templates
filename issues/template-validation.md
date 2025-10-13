## Problem

Project templates are not tested. Template changes could introduce:
- Invalid YAML syntax in workflows
- Broken pre-commit configurations
- Non-functional CI setups
- Drift from reusable workflow best practices

**Impact**: New projects created from templates may start with broken CI/CD

## Solution

Add template validation workflow that runs on every PR to validate template quality.

## Workflow to Create

**File**: `.github/workflows/validate-templates.yml`

```yaml
name: Validate Templates
on:
  pull_request:
    branches: [master]
    paths:
      - 'python-project/**'
      - 'shell-project/**'
      - '.github/workflows/validate-templates.yml'

jobs:
  validate-python:
    name: Validate Python Template
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install yamllint
        run: pip install yamllint

      - name: Validate workflow YAML syntax
        run: |
          for workflow in python-project/.github/workflows/*.yml; do
            echo "Validating $workflow"
            yamllint "$workflow"
          done

      - name: Check pyproject.toml syntax
        run: |
          pip install tomli
          python -c "import tomli; tomli.load(open('python-project/pyproject.toml', 'rb'))"

      - name: Validate pre-commit config
        run: |
          pip install pre-commit
          cd python-project
          pre-commit validate-config

      - name: Detect standalone workflows (should use reusables)
        run: |
          cd python-project/.github/workflows
          # Check if workflows have direct job definitions instead of 'uses:'
          if grep -r "runs-on: ubuntu-latest" . | grep -v "uses:" | grep -v validate; then
            echo "WARNING: Found workflows with direct job definitions"
            echo "Consider migrating to reusable workflows"
            # Don't fail, just warn for now
          fi

  validate-shell:
    name: Validate Shell Template
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Install yamllint
        run: pip install yamllint

      - name: Validate workflow YAML syntax
        run: |
          for workflow in shell-project/.github/workflows/*.yml; do
            echo "Validating $workflow"
            yamllint "$workflow"
          done

      - name: Validate pre-commit config
        run: |
          pip install pre-commit
          cd shell-project
          pre-commit validate-config

      - name: ShellCheck template scripts (if any)
        run: |
          if ls shell-project/*.sh 1> /dev/null 2>&1; then
            for script in shell-project/*.sh; do
              shellcheck "$script"
            done
          else
            echo "No shell scripts in template"
          fi

  validate-consistency:
    name: Check Template Consistency
    runs-on: ubuntu-latest
    permissions:
      contents: read

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Check both templates have WORKFLOW_README
        run: |
          test -f python-project/WORKFLOW_README.md || \
            (echo "ERROR: python-project missing WORKFLOW_README.md" && exit 1)
          test -f shell-project/WORKFLOW_README.md || \
            (echo "ERROR: shell-project missing WORKFLOW_README.md" && exit 1)

      - name: Check both templates have standard workflows
        run: |
          # Expected workflows
          workflows="ci commit-format verify-session-handoff block-ai-attribution pr-title-check pre-commit-validation protect-master"

          for workflow in $workflows; do
            test -f "python-project/.github/workflows/${workflow}.yml" || \
              echo "WARNING: python-project missing ${workflow}.yml"
            test -f "shell-project/.github/workflows/${workflow}.yml" || \
              echo "WARNING: shell-project missing ${workflow}.yml"
          done
```

## Validations Performed

### YAML Syntax Validation
- All workflow files parseable
- Valid YAML structure
- No syntax errors

### pyproject.toml Validation (Python)
- Valid TOML syntax
- Can be parsed by Python tools

### Pre-commit Config Validation
- Valid pre-commit configuration
- Hook repositories accessible
- No deprecated hooks

### Workflow Consistency Check
- Both templates have WORKFLOW_README.md
- Standard workflows present
- Similar structure between templates

### Standalone Workflow Detection
- Warns if workflows have direct jobs (should use reusables)
- Helps maintain reusable workflow adoption

## Implementation Checklist

- [ ] Create `.github/workflows/` directory (if not exists)
- [ ] Create `validate-templates.yml` workflow
- [ ] Install yamllint in workflow
- [ ] Add Python template validation job
- [ ] Add Shell template validation job
- [ ] Add consistency check job
- [ ] Test workflow with intentional errors
- [ ] Verify all validations work
- [ ] Merge to master

## Testing Plan

1. Create PR with intentional issues:
   - Invalid YAML (missing colon)
   - Invalid pyproject.toml (bad syntax)
   - Invalid pre-commit config (wrong repo)
   - Missing WORKFLOW_README.md

2. Verify workflow fails appropriately

3. Fix all issues

4. Verify workflow passes

5. Merge PR

## Expected Benefits

- **Quality Assurance**: Templates always valid
- **Fast Feedback**: Issues caught in PR, not in new projects
- **Consistency**: Both templates maintain similar structure
- **Documentation**: Validates documentation exists

## Files to Create

- `.github/workflows/validate-templates.yml`

## Acceptance Criteria

- [ ] Workflow created
- [ ] YAML validation works
- [ ] pyproject.toml validation works (Python)
- [ ] Pre-commit validation works
- [ ] Consistency checks work
- [ ] Standalone workflow detection works
- [ ] Tested with intentional errors
- [ ] Workflow passes on clean templates

## Future Enhancements (Separate Issue)

- Actually create test repository and run workflows
- Validate workflows execute successfully
- Test template instantiation (replace placeholders)
- Automated PR creation for template improvements

## Priority

**MEDIUM** - Complete in Week 2-4 (prevents template quality issues)
