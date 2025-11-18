# Project Templates

Reusable project templates with CI/CD configurations, pre-commit hooks, and best practices.

## Available Templates

### Python Project
Complete Python project setup with:
- GitHub Actions CI (tests, linting, type checking)
- Pre-commit hooks configuration
- pytest with coverage
- Modern pyproject.toml configuration
- Standard .gitignore

**Usage:**
```bash
# Using GitHub CLI (recommended)
gh repo create my-project --template maxrantil/project-templates --private
cd my-project
# Customize pyproject.toml and README.md

# Or manually
cp -r python-project/* my-new-project/
cd my-new-project
git init
# Customize and commit
```

### Shell Project
Shell script collection setup with:
- GitHub Actions ShellCheck workflow
- Pre-commit hooks with shellcheck
- Example script template
- Standard .gitignore

**Usage:**
```bash
cp -r shell-project/* my-scripts/
cd my-scripts
git init
# Add your scripts
```

### Rust Project
Complete Rust project setup with:
- GitHub Actions CI (tests, clippy, rustfmt, cargo audit)
- Pre-commit hooks configuration
- Cargo workspace configuration
- Binary and library templates
- Comprehensive quality checks
- Standard .gitignore

**Usage:**
```bash
# Using GitHub CLI (recommended)
gh repo create my-rust-project --template maxrantil/project-templates --private
cd my-rust-project
# Customize Cargo.toml and source files

# Or manually
cp -r rust-project/* my-rust-project/
cd my-rust-project
git init
# Customize Cargo.toml, src/main.rs, src/lib.rs
```

### Centralized Workflows
All templates now use centralized reusable workflows from the [maxrantil/.github](https://github.com/maxrantil/.github) repository.

**Available Reusable Workflows:**
- `python-test-reusable.yml` - Python testing with UV support (default)
- `shell-quality-reusable.yml` - ShellCheck and shfmt validation
- `conventional-commit-check-reusable.yml` - Commit message validation
- `session-handoff-check-reusable.yml` - Session handoff documentation verification

**Benefits:**
- Workflow improvements propagate instantly to all projects
- 50-75% reduction in workflow code duplication
- Consistent CI/CD behavior across all repositories
- Centralized maintenance and version control

See the [.github repository README](https://github.com/maxrantil/.github#readme) for complete usage documentation.

## Template Customization

After copying a template:

1. **Update project metadata**
   - Python: Edit `pyproject.toml` (name, version, description, author)
   - Shell: Edit `README.md`
   - Rust: Edit `Cargo.toml` (name, version, description, authors)

2. **Install dependencies**
   - Python: `pip install -e ".[dev]"`
   - Shell: `pre-commit install` (if using pre-commit)
   - Rust: `cargo build && pre-commit install`

3. **Initialize git**
   ```bash
   git init
   git add .
   git commit -m "Initial commit from template"
   ```

4. **Customize CI/CD**
   - Review `.github/workflows/` files
   - Adjust Python versions, test commands, etc.

## Contributing

When you develop new CI patterns across projects:

1. Extract the pattern to this repository
2. Add TODO comments for project-specific customization
3. Document usage in this README
4. Update existing projects to reference the template

## Development Workflow

1. Create new project from template
2. Develop and iterate
3. Extract reusable patterns back to templates
4. Share improvements across projects

## Template Quality Assurance

All templates are automatically validated on every PR to ensure quality:

### Validation Checks

The `.github/workflows/validate-templates.yml` workflow runs comprehensive checks:

**Python Template Validation:**
- ✅ YAML syntax validation (yamllint)
- ✅ pyproject.toml syntax validation
- ✅ Pre-commit config validation
- ✅ ABOUTME headers in workflows
- ✅ Reusable workflow usage verification
- ✅ Branch reference compliance (@master)

**Shell Template Validation:**
- ✅ YAML syntax validation (yamllint)
- ✅ Pre-commit config validation
- ✅ ShellCheck validation for scripts
- ✅ ABOUTME headers in workflows
- ✅ Reusable workflow usage verification
- ✅ Branch reference compliance (@master)

**Rust Template Validation:**
- ✅ YAML syntax validation (yamllint)
- ✅ Cargo.toml syntax validation
- ✅ Pre-commit config validation
- ✅ ABOUTME headers in workflows
- ✅ Reusable workflow usage verification
- ✅ Branch reference compliance (@master)

**Consistency Checks:**
- ✅ All templates have workflow documentation (README.md)
- ✅ All templates have pre-commit configs
- ✅ All templates have README files
- ✅ Standard workflows present in all templates

### Benefits

- **Fast Feedback**: Issues caught in PR, not when using templates
- **Quality Guarantee**: Templates always valid and production-ready
- **Consistency**: Both templates maintain similar structure
- **Documentation**: Validates required documentation exists

## Repository Structure

```
project-templates/
├── README.md                          # This file
├── .github/workflows/
│   ├── validate-templates.yml        # Template quality validation
│   ├── commit-format.yml             # Conventional commits
│   ├── block-ai-attribution.yml      # No AI attribution
│   ├── pr-title-check.yml            # PR title validation
│   ├── pre-commit-validation.yml     # Pre-commit hooks
│   ├── protect-master.yml            # Master branch protection
│   └── verify-session-handoff.yml    # Session handoff docs
├── python-project/                    # Python template
│   ├── .github/workflows/
│   │   ├── ci.yml                    # Uses python-test-reusable
│   │   ├── commit-format.yml         # Uses conventional-commit-check-reusable
│   │   ├── verify-session-handoff.yml # Uses session-handoff-check-reusable
│   │   ├── block-ai-attribution.yml
│   │   ├── pr-title-check.yml
│   │   ├── pre-commit-validation.yml
│   │   └── protect-master.yml
│   ├── tests/
│   │   ├── __init__.py
│   │   └── test_example.py
│   ├── .pre-commit-config.yaml
│   ├── .gitignore
│   ├── pyproject.toml
│   └── README.md
├── shell-project/                     # Shell template
│   ├── .github/workflows/
│   │   ├── ci.yml                    # Custom test runner template
│   │   ├── shell-quality.yml         # Uses shell-quality-reusable
│   │   ├── commit-format.yml         # Uses conventional-commit-check-reusable
│   │   ├── verify-session-handoff.yml # Uses session-handoff-check-reusable
│   │   ├── block-ai-attribution.yml
│   │   ├── pr-title-check.yml
│   │   ├── pre-commit-validation.yml
│   │   └── protect-master.yml
│   ├── .pre-commit-config.yaml
│   ├── .gitignore
│   ├── README.md
│   └── example-script.sh
├── rust-project/                      # Rust template
│   ├── .github/workflows/
│   │   ├── ci.yml                    # Cargo test, clippy, fmt
│   │   ├── rust-quality.yml          # Comprehensive quality checks
│   │   ├── commit-format.yml         # Uses conventional-commit-check-reusable
│   │   ├── verify-session-handoff.yml # Uses session-handoff-check-reusable
│   │   ├── block-ai-attribution.yml
│   │   ├── pr-title-check.yml
│   │   ├── pre-commit-validation.yml
│   │   ├── protect-master.yml
│   │   └── secret-scan.yml
│   ├── src/
│   │   ├── main.rs                   # Binary entry point
│   │   └── lib.rs                    # Library code
│   ├── tests/
│   │   └── integration_test.rs       # Integration tests
│   ├── scripts/
│   │   └── setup-github-protection.sh
│   ├── .pre-commit-config.yaml
│   ├── .gitignore
│   ├── Cargo.toml
│   ├── README.md
│   └── CUSTOMIZATION.md
└── Centralized workflows → https://github.com/maxrantil/.github
```

## Next Steps

**✅ Completed:**
1. ✅ Python template: Full CI/CD using centralized workflows
2. ✅ Shell template: ShellCheck + shfmt using centralized workflows
3. ✅ Rust template: Cargo test, clippy, fmt, audit using quality workflows
4. ✅ Shared workflows: Migrated to maxrantil/.github repository
5. ✅ Workflow reduction: Achieved 50%+ reduction in duplicated code

**Future Enhancements:**
1. Add more language templates (Go, TypeScript, etc.)
2. Create workflow templates for Docker/container workflows
3. Add database migration workflow templates
4. Extract deployment patterns from production projects

## Related Repositories

- **dotfiles**: Universal shell environment configuration
- **vm-infra**: Development environment provisioning
- **project-templates**: This repository (project starter templates)

Each serves a distinct purpose:
- dotfiles = base environment (shell, git, vim)
- vm-infra = infrastructure provisioning (VMs, testing)
- project-templates = project scaffolding (CI, tooling, structure)
