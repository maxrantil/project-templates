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

2. **Install dependencies**
   - Python: `pip install -e ".[dev]"`
   - Shell: `pre-commit install` (if using pre-commit)

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

## Repository Structure

```
project-templates/
├── README.md                          # This file
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
└── Centralized workflows → https://github.com/maxrantil/.github
```

## Next Steps

**✅ Completed:**
1. ✅ Python template: Full CI/CD using centralized workflows
2. ✅ Shell template: ShellCheck + shfmt using centralized workflows
3. ✅ Shared workflows: Migrated to maxrantil/.github repository
4. ✅ Workflow reduction: Achieved 50%+ reduction in duplicated code

**Future Enhancements:**
1. Add more language templates (Rust, Go, TypeScript, etc.)
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
