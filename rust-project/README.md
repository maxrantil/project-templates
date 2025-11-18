# PROJECT_NAME

PROJECT_DESCRIPTION

## Installation

```bash
# Clone the repository
git clone https://github.com/username/project-name
cd project-name

# Build the project
cargo build

# Run tests
cargo test
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

# Format code
cargo fmt

# Run linter
cargo clippy --all-targets --all-features -- -D warnings

# Run tests
cargo test

# Run tests with output
cargo test -- --nocapture

# Build documentation
cargo doc --open

# Run security audit
cargo audit
```

## Project Structure

```
rust-project/
├── src/
│   ├── main.rs        # Binary entry point
│   └── lib.rs         # Library code
├── tests/             # Integration tests
├── Cargo.toml         # Package manifest
└── .github/
    └── workflows/     # CI/CD workflows
```

## CI/CD

This template includes comprehensive GitHub Actions workflows:
- Automated testing on all PRs
- Pre-commit hook validation
- Conventional commit enforcement
- Documentation checks
- Security scanning
- Rust quality checks (clippy, fmt, audit)

See [Workflow Documentation](.github/workflows/README.md) for details.

## Usage

TODO: Add usage examples

## Building for Production

```bash
# Build optimized release binary
cargo build --release

# The binary will be in target/release/
./target/release/project-name
```

## Contributing

1. Fork the repository
2. Create a feature branch (`feat/my-feature`)
3. Make your changes
4. Run tests and quality checks
5. Commit using conventional format
6. Push and open a Pull Request

See [CLAUDE.md](../CLAUDE.md) for detailed development workflow.
