# PROJECT_NAME

PROJECT_DESCRIPTION

## Installation

```bash
pip install -e ".[dev]"
```

## GitHub Setup

After creating your repository from this template, configure branch protection and repository settings:

```bash
# Quick setup (recommended)
./scripts/setup-github-protection.sh

# Preview changes without applying
./scripts/setup-github-protection.sh --dry-run

# Manual setup or customization
# See: ../docs/GITHUB_SETUP.md
```

This will configure:
- Branch protection for `master` branch
- Required PR reviews and status checks
- Repository settings (auto-delete branches, merge options)
- Security settings (Dependabot, etc.)
- GitHub Actions permissions

For detailed documentation, see [GitHub Setup Guide](../docs/GITHUB_SETUP.md).

## Development

```bash
# Install pre-commit hooks
pre-commit install

# Run tests
pytest

# Run with coverage
pytest --cov
```

## CI/CD

This template includes comprehensive GitHub Actions workflows:
- Automated testing on all PRs
- Pre-commit hook validation
- Conventional commit enforcement
- Documentation checks

See [Workflow Documentation](.github/workflows/README.md) for details.

## Usage

TODO: Add usage examples
