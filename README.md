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

### Shared Workflows
Reusable GitHub Actions workflows that can be called from other repositories.

**Usage:**
```yaml
# In your repo's .github/workflows/ci.yml
jobs:
  test:
    uses: maxrantil/project-templates/.github/workflows/shared-test.yml@main
```

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
│   │   └── ci.yml                    # CI workflow (TODO markers)
│   ├── tests/
│   │   ├── __init__.py
│   │   └── test_example.py
│   ├── .pre-commit-config.yaml
│   ├── .gitignore
│   ├── pyproject.toml
│   └── README.md
├── shell-project/                     # Shell template
│   ├── .github/workflows/
│   │   └── shellcheck.yml
│   ├── .pre-commit-config.yaml
│   ├── .gitignore
│   ├── README.md
│   └── example-script.sh
└── shared/                            # Reusable workflows
    └── workflows/
        └── (TODO: Add reusable workflows)
```

## Next Steps

**TODO: Populate templates with actual CI configurations**

1. Python template: Add CI jobs from existing Python projects
2. Shell template: Add shellcheck configuration from existing repos
3. Shared workflows: Extract common patterns
4. Add more templates as needed (TypeScript, Go, etc.)

## Related Repositories

- **dotfiles**: Universal shell environment configuration
- **vm-infra**: Development environment provisioning
- **project-templates**: This repository (project starter templates)

Each serves a distinct purpose:
- dotfiles = base environment (shell, git, vim)
- vm-infra = infrastructure provisioning (VMs, testing)
- project-templates = project scaffolding (CI, tooling, structure)
