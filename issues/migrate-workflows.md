## Problem

Project templates contain 4 standalone workflow files per template (8 total) that duplicate logic from existing reusable workflows in `.github` repository.

**Affected Workflows** (in both `python-project/` and `shell-project/`):
1. `block-ai-attribution.yml` - 72 lines of bash logic
2. `pr-title-check.yml` - Standalone validation
3. `pre-commit-validation.yml` - Duplicated logic
4. `protect-master.yml` - Duplicated protection

**Impact**:
- Maintenance burden (update 8 files instead of 4 reusables)
- Template bloat (72 lines vs 3 lines per workflow)
- Inconsistency risk (standalone versions drift from reusables)
- Templates not using latest improvements

## Solution

Migrate all 4 workflows to use reusable versions from `.github` repository.

## Migration Examples

### Before: block-ai-attribution.yml (72 lines)

```yaml
name: Block AI Attribution
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-attribution:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0

      - name: Check for AI/agent attribution in commit messages
        run: |
          # 60+ lines of bash logic...
```

### After: block-ai-attribution.yml (3 lines)

```yaml
name: Block AI Attribution
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-attribution:
    uses: maxrantil/.github/.github/workflows/block-ai-attribution-reusable.yml@main
```

**Code reduction**: 72 lines → 3 lines (96% reduction)

---

## Workflows to Migrate

### 1. block-ai-attribution.yml

**Current**: Standalone implementation
**Target**: Use `block-ai-attribution-reusable.yml`

**Python Template**:
```yaml
name: Block AI Attribution
on:
  pull_request:
    types: [opened, synchronize, reopened]

jobs:
  check-attribution:
    uses: maxrantil/.github/.github/workflows/block-ai-attribution-reusable.yml@main
```

**Shell Template**: Same

---

### 2. pr-title-check.yml

**Current**: Standalone implementation
**Target**: Use `pr-title-check-reusable.yml`

```yaml
name: PR Title Check
on:
  pull_request:
    types: [opened, edited, synchronize]

jobs:
  check-title:
    uses: maxrantil/.github/.github/workflows/pr-title-check-reusable.yml@main
```

---

### 3. pre-commit-validation.yml

**Current**: Standalone implementation
**Target**: Use `pre-commit-check-reusable.yml`

```yaml
name: Pre-commit Validation
on:
  pull_request:
    branches: [master]

jobs:
  pre-commit:
    uses: maxrantil/.github/.github/workflows/pre-commit-check-reusable.yml@main
```

---

### 4. protect-master.yml

**Current**: Standalone implementation
**Target**: Use `protect-master-reusable.yml`

```yaml
name: Protect Master Branch
on:
  push:
    branches:
      - master

jobs:
  block-direct-push:
    uses: maxrantil/.github/.github/workflows/protect-master-reusable.yml@main
```

---

## Implementation Checklist

### Python Template
- [ ] Migrate `python-project/.github/workflows/block-ai-attribution.yml`
- [ ] Migrate `python-project/.github/workflows/pr-title-check.yml`
- [ ] Migrate `python-project/.github/workflows/pre-commit-validation.yml`
- [ ] Migrate `python-project/.github/workflows/protect-master.yml`

### Shell Template
- [ ] Migrate `shell-project/.github/workflows/block-ai-attribution.yml`
- [ ] Migrate `shell-project/.github/workflows/pr-title-check.yml`
- [ ] Migrate `shell-project/.github/workflows/pre-commit-validation.yml`
- [ ] Migrate `shell-project/.github/workflows/protect-master.yml`

### Validation
- [ ] Create test repository from Python template
- [ ] Create test PR with issues (AI attribution, bad title, etc.)
- [ ] Verify all workflows run correctly
- [ ] Create test repository from Shell template
- [ ] Verify Shell template workflows work
- [ ] Delete test repositories

### Documentation
- [ ] Update WORKFLOW_README.md in Python template
- [ ] Update WORKFLOW_README.md in Shell template
- [ ] Note that workflows use reusables

## Expected Benefits

**Code Reduction**:
- Python template: ~200 lines → ~30 lines
- Shell template: ~200 lines → ~30 lines
- **Total**: 400 lines → 60 lines (85% reduction)

**Maintenance**:
- Updates in `.github` automatically propagate
- No need to update 8 files
- Consistency guaranteed

**Quality**:
- Templates always use latest workflow improvements
- No drift between standalone and reusable versions

## Testing Plan

1. Create test repository from Python template:
   ```bash
   gh repo create test-python-migration --template maxrantil/project-templates --private
   cd test-python-migration
   # Copy python-project/* to root
   ```

2. Create test PR with issues:
   - Commit with AI attribution: `feat: add feature (Claude Code wrote this)`
   - PR title: `Added feature` (not conventional)
   - Skip pre-commit: `git commit --no-verify`

3. Verify workflows fail appropriately:
   - AI attribution blocked
   - PR title rejected
   - Pre-commit enforcement works

4. Fix issues and verify workflows pass

5. Repeat for Shell template

6. Clean up test repositories

## Files to Update

```
python-project/.github/workflows/
├── block-ai-attribution.yml       (migrate)
├── pr-title-check.yml             (migrate)
├── pre-commit-validation.yml      (migrate)
└── protect-master.yml             (migrate)

shell-project/.github/workflows/
├── block-ai-attribution.yml       (migrate)
├── pr-title-check.yml             (migrate)
├── pre-commit-validation.yml      (migrate)
└── protect-master.yml             (migrate)

python-project/WORKFLOW_README.md  (update)
shell-project/WORKFLOW_README.md   (update)
```

## Acceptance Criteria

- [ ] All 4 workflows migrated in Python template
- [ ] All 4 workflows migrated in Shell template
- [ ] 85% code reduction achieved
- [ ] Workflows tested in test repositories
- [ ] All workflows pass validation
- [ ] Documentation updated
- [ ] No functionality lost

## Priority

**MEDIUM** - Complete in Week 2-4 (reduces maintenance burden)
