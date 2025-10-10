# GitHub Repository Setup Guide

This guide covers the recommended GitHub repository settings for projects created from these templates. These settings ensure quality, security, and consistent workflows across all projects.

**🔴 IMPORTANT: This guide assumes you're using `master` as your default branch (not `main`). All instructions reference `master`.**

## Quick Start

### Automated Setup (Recommended)

Use the provided setup script to configure branch protection automatically:

```bash
# From your project root (Python template)
./scripts/setup-github-protection.sh

# From your project root (Shell template)
./scripts/setup-github-protection.sh
```

The script will:
- Configure branch protection for `master` branch
- Require PR reviews before merging
- Require status checks to pass
- Enable administrator enforcement
- Set up required CI checks

### Manual Setup

If you prefer manual configuration or need to customize settings, follow the sections below.

---

## Branch Protection Rules

Branch protection prevents direct pushes to important branches and enforces code review and CI checks.

### Recommended Settings for `master` Branch

**Navigate to:** Repository → Settings → Branches → Add branch protection rule

#### Basic Protection

- **Branch name pattern:** `master`
- ✅ **Require a pull request before merging**
  - Required approvals: `1`
  - ✅ Dismiss stale pull request approvals when new commits are pushed
  - ✅ Require review from Code Owners (if using CODEOWNERS)
- ✅ **Require status checks to pass before merging**
  - ✅ Require branches to be up to date before merging
  - **Required checks:** (select all that apply to your template)
    - `ci` (test suite)
    - `pre-commit-validation` (pre-commit hooks)
    - `pr-title-check` (conventional commits)
    - `commit-format` (commit message validation)
    - `block-ai-attribution` (no AI mentions)
    - `verify-session-handoff` (documentation check)

#### Advanced Protection

- ✅ **Require conversation resolution before merging**
- ✅ **Require signed commits** (optional, but recommended)
- ✅ **Include administrators** (enforce rules for admins too)
- ✅ **Restrict who can push to matching branches**
  - Leave empty to prevent all direct pushes
- ✅ **Allow force pushes:** DISABLED
- ✅ **Allow deletions:** DISABLED

### Using GitHub CLI

```bash
# Set branch protection with required status checks
gh api repos/:owner/:repo/branches/master/protection \
  --method PUT \
  --field required_status_checks[strict]=true \
  --field required_status_checks[contexts][]=ci \
  --field required_status_checks[contexts][]=pre-commit-validation \
  --field required_status_checks[contexts][]=pr-title-check \
  --field required_status_checks[contexts][]=commit-format \
  --field required_status_checks[contexts][]=block-ai-attribution \
  --field required_status_checks[contexts][]=verify-session-handoff \
  --field enforce_admins=true \
  --field required_pull_request_reviews[required_approving_review_count]=1 \
  --field required_pull_request_reviews[dismiss_stale_reviews]=true \
  --field restrictions=null
```

---

## Repository Settings

### General Settings

**Navigate to:** Repository → Settings → General

#### Default Branch
- Set default branch to `master` (REQUIRED - never use `main`)
- **Important:** If your repository was created with `main` as default, rename it to `master`:
  ```bash
  git branch -m main master
  git push -u origin master
  gh repo edit --default-branch master
  git push origin --delete main
  ```

#### Pull Requests
- ✅ **Allow squash merging** (keep clean history on master)
- ✅ **Automatically delete head branches** (cleanup after merge)
- ❌ **Allow merge commits** (optional, your preference)
- ❌ **Allow rebase merging** (optional, your preference)

#### Archives
- ❌ **Do not include Git LFS objects in archives**

### Actions Settings

**Navigate to:** Repository → Settings → Actions → General

#### Actions permissions
- ✅ **Allow all actions and reusable workflows**

#### Workflow permissions
- ✅ **Read and write permissions** (required for workflows)
- ✅ **Allow GitHub Actions to create and approve pull requests**

#### Fork pull request workflows
- ✅ **Require approval for first-time contributors** (security)

---

## Collaborators & Teams

### Adding Collaborators

**Navigate to:** Repository → Settings → Collaborators and teams

#### Recommended Roles
- **Admin:** Project leads only
- **Maintain:** Senior developers
- **Write:** All contributing developers
- **Read:** Observers, documentation reviewers

### Using GitHub CLI

```bash
# Add collaborator with write access
gh api repos/:owner/:repo/collaborators/:username \
  --method PUT \
  --field permission=push

# Add team with maintain access
gh api orgs/:org/teams/:team/repos/:owner/:repo \
  --method PUT \
  --field permission=maintain
```

---

## Secrets and Variables

### Required Secrets

**Navigate to:** Repository → Settings → Secrets and variables → Actions

Most projects won't need secrets initially, but here are common ones:

- `PYPI_TOKEN` - For Python package publishing
- `CODECOV_TOKEN` - For code coverage reporting
- `DOCKER_USERNAME` / `DOCKER_TOKEN` - For container publishing

### Using GitHub CLI

```bash
# Add repository secret
gh secret set SECRET_NAME --body "secret-value"

# Add from file
gh secret set SECRET_NAME < secret-file.txt
```

---

## GitHub Actions

### Workflow Configuration

Your template includes pre-configured workflows in `.github/workflows/`. See `.github/workflows/README.md` for detailed documentation.

**Key workflows:**
- `ci.yml` - Runs tests on every push/PR
- `pre-commit-validation.yml` - Validates pre-commit hooks
- `pr-title-check.yml` - Enforces conventional commit format
- `commit-format.yml` - Validates all commit messages
- `block-ai-attribution.yml` - Prevents AI attribution in commits
- `verify-session-handoff.yml` - Ensures documentation exists
- `protect-master.yml` - Blocks direct pushes to master

### Troubleshooting Workflows

If CI checks fail, see `.github/workflows/README.md` for debugging guides and common issues.

---

## Issue and PR Templates

### Setting Up Templates

Templates are already included in `.github/` directories:

- `.github/ISSUE_TEMPLATE/` - Issue templates
- `.github/PULL_REQUEST_TEMPLATE.md` - PR template

### Customization

Edit templates to match your project's needs:
```bash
# Python template
vim python-project/.github/PULL_REQUEST_TEMPLATE.md

# Shell template
vim shell-project/.github/PULL_REQUEST_TEMPLATE.md
```

---

## CODEOWNERS File (Optional)

Create `.github/CODEOWNERS` to automatically request reviews from specific people:

```
# Global owners
* @your-username

# Python-specific
*.py @python-team
tests/ @qa-team

# CI/CD
.github/workflows/ @devops-team

# Documentation
docs/ @docs-team
*.md @docs-team
```

### Using GitHub CLI

```bash
# CODEOWNERS is a file, not a setting
echo "* @your-username" > .github/CODEOWNERS
git add .github/CODEOWNERS
git commit -m "chore: add CODEOWNERS file"
git push
```

---

## Security Settings

### Recommended Security Features

**Navigate to:** Repository → Settings → Security

#### Dependabot
- ✅ **Enable Dependabot alerts**
- ✅ **Enable Dependabot security updates**
- ✅ **Enable Dependabot version updates** (optional)

#### Code scanning
- ✅ **Enable CodeQL analysis** (for supported languages)

#### Secret scanning
- ✅ **Enable secret scanning** (automatically enabled for public repos)

### Using GitHub CLI

```bash
# Enable vulnerability alerts
gh api repos/:owner/:repo \
  --method PATCH \
  --field security_and_analysis[dependabot_alerts][enabled]=true

# Enable automated security fixes
gh api repos/:owner/:repo \
  --method PATCH \
  --field security_and_analysis[dependabot_security_updates][enabled]=true
```

---

## Verification Checklist

After setup, verify everything is configured correctly:

- [ ] Branch protection enabled for `master`
- [ ] Required status checks configured
- [ ] PR reviews required before merge
- [ ] Direct pushes to master blocked
- [ ] GitHub Actions workflows running
- [ ] Pre-commit hooks installed locally (`pre-commit install`)
- [ ] Test workflow passes (`git push` to feature branch)
- [ ] Dependabot alerts enabled
- [ ] Collaborators added with appropriate permissions
- [ ] Issue/PR templates working

---

## Common Issues

### Status Checks Not Appearing

**Problem:** Required status checks not showing in branch protection

**Solution:**
1. Push a commit to trigger workflows
2. Wait for workflows to complete at least once
3. Return to branch protection settings
4. Status checks will now appear in the list

### Cannot Push to Master

**Problem:** `remote: error: GH006: Protected branch update failed`

**Solution:**
- This is expected! Branch protection is working.
- Create a feature branch: `git checkout -b feat/my-feature`
- Push the branch: `git push -u origin feat/my-feature`
- Create a PR on GitHub

### Workflow Permissions Error

**Problem:** Workflows fail with permission errors

**Solution:**
1. Navigate to Settings → Actions → General → Workflow permissions
2. Select "Read and write permissions"
3. Save changes
4. Re-run failed workflow

### Pre-commit Hooks Failing

**Problem:** Commits blocked by pre-commit hooks

**Solution:**
- This is expected! Hooks enforce code quality.
- Fix the issues reported by hooks
- Commit again
- See `.github/workflows/README.md` for troubleshooting specific hooks

---

## Additional Resources

- [GitHub Branch Protection Documentation](https://docs.github.com/en/repositories/configuring-branches-and-merges-in-your-repository/managing-protected-branches)
- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [GitHub CLI Documentation](https://cli.github.com/manual/)
- [Conventional Commits Specification](https://www.conventionalcommits.org/)
- [Pre-commit Framework](https://pre-commit.com/)

---

## Automation Script Reference

The included `scripts/setup-github-protection.sh` script automates most of these settings. For details on what the script does and how to customize it, see the script itself or the sections above.

**Script location:**
- Python template: `python-project/scripts/setup-github-protection.sh`
- Shell template: `shell-project/scripts/setup-github-protection.sh`

**Usage:**
```bash
./scripts/setup-github-protection.sh [options]

Options:
  --help              Show help message
  --dry-run           Show what would be done without making changes
  --owner OWNER       Repository owner (default: auto-detect)
  --repo REPO         Repository name (default: auto-detect)
  --reviewers N       Required PR reviewers (default: 1)
```
