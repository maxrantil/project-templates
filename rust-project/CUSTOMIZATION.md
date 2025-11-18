# Rust Project Template Customization

This guide explains how to customize this template for your new Rust project.

## Quick Start

1. **Copy template** to your project directory
2. **Follow checklist** below
3. **Test workflows** with a test PR
4. **Start developing**

---

## Customization Checklist

### 1. Update Project Metadata

**File**: `Cargo.toml`

```toml
[package]
name = "your-project-name"                   # Change this (lowercase, hyphens)
version = "0.1.0"
edition = "2021"
authors = ["Your Name <you@example.com>"]   # Change this
description = "Your project description"     # Change this
license = "MIT"                              # Choose appropriate license
repository = "https://github.com/username/your-project-name"  # Change this

[[bin]]
name = "your-project-name"                   # Change to match package name
path = "src/main.rs"

[lib]
name = "your_project_name"                   # Change this (snake_case)
path = "src/lib.rs"
```

**Note**: Library name uses snake_case, binary/package name uses kebab-case.

---

### 2. Update Source Files

**Files to update**:
- `src/main.rs` - Update app logic
- `src/lib.rs` - Change `project_name` references to your library name
- `tests/integration_test.rs` - Update `use project_name::*` to your library name

---

### 3. Update README

**File**: `README.md`

- [ ] Replace project title
- [ ] Update description
- [ ] Customize installation instructions
- [ ] Add your project-specific sections
- [ ] Update badge URLs (if using badges)
- [ ] Update binary name in usage examples

---

### 4. Customize Workflows (Optional)

All workflows use reusable workflows from [maxrantil/.github](https://github.com/maxrantil/.github).

**File**: `.github/workflows/ci.yml`

Rust-specific customizations:

```yaml
env:
  CARGO_TERM_COLOR: always
  RUSTFLAGS: "-D warnings"  # Add to make warnings fail build

jobs:
  test:
    steps:
      # ... existing steps ...
      - name: Run tests with specific features
        run: cargo test --features "feature1,feature2"
```

See [workflow documentation](https://github.com/maxrantil/.github#reusable-workflows) for more options.

---

### 5. Pre-commit Configuration (Optional)

**File**: `.pre-commit-config.yaml`

Add project-specific hooks:

```yaml
repos:
  # ... existing hooks ...

  # Add additional Rust checks
  - repo: https://github.com/doublify/pre-commit-rust
    rev: v1.0
    hooks:
      - id: cargo-check
```

**Customize Clippy lints**:

Create `.clippy.toml` or add to `Cargo.toml`:

```toml
[workspace.lints.clippy]
# Deny specific lints
all = "deny"
pedantic = "warn"
nursery = "warn"
```

---

### 6. Dependencies

**Add dependencies**:
```bash
cargo add serde tokio
```

**Add dev dependencies**:
```bash
cargo add --dev criterion
```

**Update dependencies**:
```bash
cargo update
```

---

### 7. Remove Template Files

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

### Add Code Coverage

Install `tarpaulin` or `llvm-cov`:

```yaml
# .github/workflows/ci.yml
jobs:
  test:
    steps:
      # ... existing steps ...
      - name: Install tarpaulin
        run: cargo install cargo-tarpaulin

      - name: Generate coverage
        run: cargo tarpaulin --out Xml

      - name: Upload coverage
        uses: codecov/codecov-action@v3
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
  curl -s "$TEMPLATE_URL/rust-project/.github/workflows/$workflow" \
    > ".github/workflows/$workflow"
done

echo "✓ Workflows synced from template"
```

---

## Testing Your Customizations

### 1. Test Locally

```bash
# Build
cargo build

# Run tests
cargo test

# Format check
cargo fmt --check

# Clippy
cargo clippy --all-targets --all-features -- -D warnings

# Security audit
cargo audit

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
- [ ] CI (cargo test, clippy, fmt)
- [ ] Rust Quality (clippy, fmt, audit, doc)
- [ ] Commit format
- [ ] Session handoff
- [ ] AI attribution blocking
- [ ] PR title check
- [ ] Pre-commit validation
- [ ] Protect master (branch protection)

---

## Common Customizations

### Binary-Only Project

If you don't need a library:

1. Remove `src/lib.rs`
2. Remove `tests/` directory
3. Update `Cargo.toml`:

```toml
# Remove [lib] section
# Keep only [[bin]]
[[bin]]
name = "your-project-name"
path = "src/main.rs"
```

### Library-Only Project

If you don't need a binary:

1. Remove `src/main.rs`
2. Update `Cargo.toml`:

```toml
# Remove [[bin]] section
# Keep only [lib]
[lib]
name = "your_project_name"
path = "src/lib.rs"
```

### Multiple Binaries

```toml
[[bin]]
name = "cli-tool"
path = "src/bin/cli.rs"

[[bin]]
name = "server"
path = "src/bin/server.rs"
```

### Workspace Setup

For multi-crate projects:

```toml
# Root Cargo.toml
[workspace]
members = ["crate1", "crate2"]

[workspace.package]
version = "0.1.0"
edition = "2021"
```

---

## Troubleshooting

### Workflows failing after customization

1. Check workflow syntax: `yamllint .github/workflows/`
2. Verify Rust syntax: `cargo check`
3. Check [workflow docs](https://github.com/maxrantil/.github#reusable-workflows)

### Pre-commit hooks failing

```bash
# Update hooks
pre-commit autoupdate

# Run specific hook
pre-commit run cargo-fmt --all-files
```

### Clippy failing with too many warnings

Add to `Cargo.toml`:

```toml
[lints.clippy]
# Customize lint levels
pedantic = "warn"  # Change to "allow" if too strict
```

### Dependency conflicts

```bash
# Clear cache and rebuild
cargo clean
cargo update
cargo build
```

---

## Getting Help

- **Workflow issues**: See [.github repository](https://github.com/maxrantil/.github)
- **Template issues**: Open issue in [project-templates](https://github.com/maxrantil/project-templates)
- **Rust/Cargo issues**: Check [Rust Book](https://doc.rust-lang.org/book/)

---

**Template Version**: 2025-11-18
**Last Updated**: 2025-11-18
