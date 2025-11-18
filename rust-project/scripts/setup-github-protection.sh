#!/usr/bin/env bash
# ABOUTME: Automates GitHub branch protection and repository settings setup for Rust projects

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
DRY_RUN=false
REQUIRED_REVIEWERS=1
OWNER=""
REPO=""

# Help message
show_help() {
    cat << EOF
Usage: ${0##*/} [OPTIONS]

Automates GitHub repository branch protection and settings configuration for Rust projects.

OPTIONS:
    -h, --help              Show this help message
    -d, --dry-run           Show what would be done without making changes
    -o, --owner OWNER       Repository owner (default: auto-detect from git remote)
    -r, --repo REPO         Repository name (default: auto-detect from git remote)
    -n, --reviewers N       Required PR reviewers (default: 1)

EXAMPLES:
    ${0##*/}                              # Auto-detect repo and configure
    ${0##*/} --dry-run                    # Preview changes without applying
    ${0##*/} --owner myuser --repo myproject
    ${0##*/} --reviewers 2                # Require 2 reviewers

REQUIREMENTS:
    - GitHub CLI (gh) installed and authenticated
    - Admin access to the target repository
    - Repository must exist on GitHub

EOF
}

# Parse command line arguments
parse_args() {
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -d|--dry-run)
                DRY_RUN=true
                shift
                ;;
            -o|--owner)
                OWNER="$2"
                shift 2
                ;;
            -r|--repo)
                REPO="$2"
                shift 2
                ;;
            -n|--reviewers)
                REQUIRED_REVIEWERS="$2"
                shift 2
                ;;
            *)
                echo -e "${RED}Error: Unknown option: $1${NC}" >&2
                show_help
                exit 1
                ;;
        esac
    done
}

# Print colored message
print_msg() {
    local color=$1
    shift
    echo -e "${color}$*${NC}"
}

# Check prerequisites
check_prerequisites() {
    print_msg "$BLUE" "🔍 Checking prerequisites..."

    # Check if gh is installed
    if ! command -v gh &> /dev/null; then
        print_msg "$RED" "❌ GitHub CLI (gh) is not installed"
        print_msg "$YELLOW" "Install it from: https://cli.github.com/"
        exit 1
    fi

    # Check if gh is authenticated
    if ! gh auth status &> /dev/null; then
        print_msg "$RED" "❌ GitHub CLI is not authenticated"
        print_msg "$YELLOW" "Run: gh auth login"
        exit 1
    fi

    print_msg "$GREEN" "✅ Prerequisites satisfied"
}

# Auto-detect repository from git remote
detect_repo() {
    if [[ -z "$OWNER" ]] || [[ -z "$REPO" ]]; then
        print_msg "$BLUE" "🔍 Auto-detecting repository from git remote..."

        # Get remote URL
        local remote_url
        remote_url=$(git config --get remote.origin.url 2>/dev/null || true)

        if [[ -z "$remote_url" ]]; then
            print_msg "$RED" "❌ Could not detect git remote"
            print_msg "$YELLOW" "Please specify --owner and --repo manually"
            exit 1
        fi

        # Parse owner and repo from URL
        # Supports both HTTPS and SSH formats
        if [[ "$remote_url" =~ github\.com[:/]([^/]+)/([^/.]+)(\.git)?$ ]]; then
            OWNER="${BASH_REMATCH[1]}"
            REPO="${BASH_REMATCH[2]}"
        else
            print_msg "$RED" "❌ Could not parse GitHub owner/repo from: $remote_url"
            exit 1
        fi
    fi

    print_msg "$GREEN" "✅ Detected repository: $OWNER/$REPO"
}

# Verify repository exists and we have access
verify_repo_access() {
    print_msg "$BLUE" "🔍 Verifying repository access..."

    if ! gh api "repos/$OWNER/$REPO" &> /dev/null; then
        print_msg "$RED" "❌ Cannot access repository: $OWNER/$REPO"
        print_msg "$YELLOW" "Check that:"
        print_msg "$YELLOW" "  - Repository exists on GitHub"
        print_msg "$YELLOW" "  - You have admin access"
        print_msg "$YELLOW" "  - GitHub CLI is authenticated correctly"
        exit 1
    fi

    print_msg "$GREEN" "✅ Repository access verified"
}

# Execute or preview API call
execute_api_call() {
    local description=$1
    shift

    if [[ "$DRY_RUN" == true ]]; then
        print_msg "$YELLOW" "  [DRY RUN] Would execute: gh $*"
    else
        print_msg "$BLUE" "  Executing: $description"
        if gh "$@"; then
            print_msg "$GREEN" "  ✅ Success"
        else
            print_msg "$RED" "  ❌ Failed"
            return 1
        fi
    fi
}

# Configure branch protection
configure_branch_protection() {
    print_msg "$BLUE" "🔐 Configuring branch protection for master branch..."

    # Build the protection configuration
    local protection_config
    protection_config=$(cat <<EOF
{
  "required_status_checks": {
    "strict": true,
    "contexts": [
      "Test Suite",
      "Clippy (Linter)",
      "Formatting Check",
      "Security Audit",
      "Documentation Check",
      "pre-commit-validation",
      "pr-title-check",
      "commit-format",
      "block-ai-attribution",
      "verify-session-handoff"
    ]
  },
  "enforce_admins": true,
  "required_pull_request_reviews": {
    "required_approving_review_count": $REQUIRED_REVIEWERS,
    "dismiss_stale_reviews": true
  },
  "restrictions": null,
  "required_conversation_resolution": true,
  "allow_force_pushes": false,
  "allow_deletions": false
}
EOF
)

    if [[ "$DRY_RUN" == true ]]; then
        print_msg "$YELLOW" "  [DRY RUN] Would configure branch protection:"
        echo "$protection_config" | jq '.'
    else
        execute_api_call "Setting branch protection" \
            api "repos/$OWNER/$REPO/branches/master/protection" \
            --method PUT \
            --input - <<< "$protection_config"
    fi
}

# Configure repository settings
configure_repo_settings() {
    print_msg "$BLUE" "⚙️  Configuring repository settings..."

    # Enable auto-delete of head branches
    execute_api_call "Enable auto-delete head branches" \
        api "repos/$OWNER/$REPO" \
        --method PATCH \
        --field delete_branch_on_merge=true

    # Allow squash merging
    execute_api_call "Enable squash merging" \
        api "repos/$OWNER/$REPO" \
        --method PATCH \
        --field allow_squash_merge=true

    # Disable merge commits (optional - comment out if you want them)
    execute_api_call "Disable merge commits" \
        api "repos/$OWNER/$REPO" \
        --method PATCH \
        --field allow_merge_commit=false

    # Disable rebase merging (optional - comment out if you want it)
    execute_api_call "Disable rebase merging" \
        api "repos/$OWNER/$REPO" \
        --method PATCH \
        --field allow_rebase_merge=false
}

# Configure security settings
configure_security_settings() {
    print_msg "$BLUE" "🔒 Configuring security settings..."

    # Enable Dependabot alerts
    execute_api_call "Enable Dependabot alerts" \
        api "repos/$OWNER/$REPO" \
        --method PATCH \
        --field security_and_analysis[dependabot_alerts][enabled]=true || true

    # Enable Dependabot security updates
    execute_api_call "Enable Dependabot security updates" \
        api "repos/$OWNER/$REPO" \
        --method PATCH \
        --field security_and_analysis[dependabot_security_updates][enabled]=true || true
}

# Configure Actions permissions
configure_actions_permissions() {
    print_msg "$BLUE" "🎬 Configuring GitHub Actions permissions..."

    # Set workflow permissions to read/write
    execute_api_call "Set Actions permissions to read/write" \
        api "repos/$OWNER/$REPO/actions/permissions/workflow" \
        --method PUT \
        --field default_workflow_permissions=write \
        --field can_approve_pull_request_reviews=true
}

# Main execution
main() {
    parse_args "$@"

    print_msg "$BLUE" "╔════════════════════════════════════════════╗"
    print_msg "$BLUE" "║  GitHub Rust Project Setup Script         ║"
    print_msg "$BLUE" "╚════════════════════════════════════════════╝"
    echo

    if [[ "$DRY_RUN" == true ]]; then
        print_msg "$YELLOW" "⚠️  DRY RUN MODE - No changes will be made"
        echo
    fi

    check_prerequisites
    detect_repo
    verify_repo_access

    echo
    print_msg "$BLUE" "📋 Configuration Summary:"
    print_msg "$BLUE" "  Repository: $OWNER/$REPO"
    print_msg "$BLUE" "  Required Reviewers: $REQUIRED_REVIEWERS"
    print_msg "$BLUE" "  Dry Run: $DRY_RUN"
    echo

    if [[ "$DRY_RUN" == false ]]; then
        read -p "Continue with configuration? (y/N) " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            print_msg "$YELLOW" "⚠️  Setup cancelled"
            exit 0
        fi
    fi

    echo
    configure_branch_protection
    echo
    configure_repo_settings
    echo
    configure_security_settings
    echo
    configure_actions_permissions

    echo
    if [[ "$DRY_RUN" == true ]]; then
        print_msg "$YELLOW" "✅ Dry run complete - no changes were made"
        print_msg "$YELLOW" "Run without --dry-run to apply changes"
    else
        print_msg "$GREEN" "╔════════════════════════════════════════════╗"
        print_msg "$GREEN" "║  ✅ Setup Complete!                        ║"
        print_msg "$GREEN" "╚════════════════════════════════════════════╝"
        echo
        print_msg "$BLUE" "Next steps:"
        print_msg "$BLUE" "  1. Install pre-commit hooks locally: pre-commit install"
        print_msg "$BLUE" "  2. Create a feature branch: git checkout -b feat/my-feature"
        print_msg "$BLUE" "  3. Push and create a PR to test the setup"
        echo
        print_msg "$BLUE" "For more information, see: docs/GITHUB_SETUP.md"
    fi
}

# Run main function
main "$@"
