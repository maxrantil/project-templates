#!/bin/bash
# ABOUTME: End-to-end test for template customization documentation

set -euo pipefail

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Test counters
TESTS_RUN=0
TESTS_PASSED=0
TESTS_FAILED=0

# Logging functions
log_info() {
  printf "${GREEN}[INFO]${NC} %s\n" "$*"
}

log_warn() {
  printf "${YELLOW}[WARN]${NC} %s\n" "$*"
}

log_error() {
  printf "${RED}[ERROR]${NC} %s\n" "$*"
}

test_pass() {
  ((TESTS_PASSED++))
  log_info "✓ $1"
}

test_fail() {
  ((TESTS_FAILED++))
  log_error "✗ $1"
}

run_test() {
  ((TESTS_RUN++))
}

# Get script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"

# Create temp directory for testing
TEMP_DIR=$(mktemp -d -t template-test-XXXXXX)

# Cleanup function
cleanup() {
  if [[ -d "$TEMP_DIR" ]]; then
    rm -rf "$TEMP_DIR"
  fi
}
trap cleanup EXIT

log_info "Testing template customization documentation"
log_info "Project root: $PROJECT_ROOT"
log_info "Test directory: $TEMP_DIR"
printf "\n"

# =============================================================================
# Test 1: Python Template Copy
# =============================================================================
run_test
log_info "Test 1: Copying Python template..."
if cp -r "$PROJECT_ROOT/python-project" "$TEMP_DIR/test-python-project"; then
  test_pass "Python template copied successfully"
else
  test_fail "Failed to copy Python template"
fi

# =============================================================================
# Test 2: Python Template Structure
# =============================================================================
run_test
log_info "Test 2: Verifying Python template structure..."
PYTHON_DIR="$TEMP_DIR/test-python-project"
REQUIRED_FILES=(
  "CUSTOMIZATION.md"
  "README.md"
  "pyproject.toml"
  ".pre-commit-config.yaml"
  ".github/workflows/ci.yml"
  ".github/workflows/commit-format.yml"
  ".github/workflows/verify-session-handoff.yml"
)

MISSING_FILES=()
for file in "${REQUIRED_FILES[@]}"; do
  if [[ ! -f "$PYTHON_DIR/$file" ]]; then
    MISSING_FILES+=("$file")
  fi
done

if [[ ${#MISSING_FILES[@]} -eq 0 ]]; then
  test_pass "All required Python files present"
else
  test_fail "Missing Python files: ${MISSING_FILES[*]}"
fi

# =============================================================================
# Test 3: Python pyproject.toml Validation
# =============================================================================
run_test
log_info "Test 3: Validating Python pyproject.toml..."
if grep -q "name = \"python-project\"" "$PYTHON_DIR/pyproject.toml"; then
  test_pass "pyproject.toml has correct project name placeholder"
else
  test_fail "pyproject.toml missing or malformed"
fi

# =============================================================================
# Test 4: Python Workflow References
# =============================================================================
run_test
log_info "Test 4: Checking Python workflow references..."
WORKFLOW_FILE="$PYTHON_DIR/.github/workflows/ci.yml"
if grep -q "@master" "$WORKFLOW_FILE" && ! grep -q "@main" "$WORKFLOW_FILE"; then
  test_pass "Python workflows correctly reference @master"
else
  test_fail "Python workflows have incorrect branch references"
fi

# =============================================================================
# Test 5: Shell Template Copy
# =============================================================================
run_test
log_info "Test 5: Copying Shell template..."
if cp -r "$PROJECT_ROOT/shell-project" "$TEMP_DIR/test-shell-project"; then
  test_pass "Shell template copied successfully"
else
  test_fail "Failed to copy Shell template"
fi

# =============================================================================
# Test 6: Shell Template Structure
# =============================================================================
run_test
log_info "Test 6: Verifying Shell template structure..."
SHELL_DIR="$TEMP_DIR/test-shell-project"
REQUIRED_SHELL_FILES=(
  "CUSTOMIZATION.md"
  "README.md"
  ".pre-commit-config.yaml"
  ".github/workflows/ci.yml"
  ".github/workflows/shell-quality.yml"
  ".github/workflows/commit-format.yml"
)

MISSING_SHELL_FILES=()
for file in "${REQUIRED_SHELL_FILES[@]}"; do
  if [[ ! -f "$SHELL_DIR/$file" ]]; then
    MISSING_SHELL_FILES+=("$file")
  fi
done

if [[ ${#MISSING_SHELL_FILES[@]} -eq 0 ]]; then
  test_pass "All required Shell files present"
else
  test_fail "Missing Shell files: ${MISSING_SHELL_FILES[*]}"
fi

# =============================================================================
# Test 7: Shell Workflow References
# =============================================================================
run_test
log_info "Test 7: Checking Shell workflow references..."
SHELL_WORKFLOW="$SHELL_DIR/.github/workflows/ci.yml"
if grep -q "@master" "$SHELL_WORKFLOW" && ! grep -q "@main" "$SHELL_WORKFLOW"; then
  test_pass "Shell workflows correctly reference @master"
else
  test_fail "Shell workflows have incorrect branch references"
fi

# =============================================================================
# Test 8: CUSTOMIZATION.md Completeness (Python)
# =============================================================================
run_test
log_info "Test 8: Checking Python CUSTOMIZATION.md completeness..."
PYTHON_CUSTOM="$PYTHON_DIR/CUSTOMIZATION.md"
REQUIRED_SECTIONS=(
  "Quick Start"
  "Customization Checklist"
  "Update Project Metadata"
  "Testing Your Customizations"
  "Troubleshooting"
)

MISSING_SECTIONS=()
for section in "${REQUIRED_SECTIONS[@]}"; do
  if ! grep -q "$section" "$PYTHON_CUSTOM"; then
    MISSING_SECTIONS+=("$section")
  fi
done

if [[ ${#MISSING_SECTIONS[@]} -eq 0 ]]; then
  test_pass "Python CUSTOMIZATION.md has all required sections"
else
  test_fail "Python CUSTOMIZATION.md missing sections: ${MISSING_SECTIONS[*]}"
fi

# =============================================================================
# Test 9: CUSTOMIZATION.md Completeness (Shell)
# =============================================================================
run_test
log_info "Test 9: Checking Shell CUSTOMIZATION.md completeness..."
SHELL_CUSTOM="$SHELL_DIR/CUSTOMIZATION.md"

MISSING_SHELL_SECTIONS=()
for section in "${REQUIRED_SECTIONS[@]}"; do
  if ! grep -q "$section" "$SHELL_CUSTOM"; then
    MISSING_SHELL_SECTIONS+=("$section")
  fi
done

if [[ ${#MISSING_SHELL_SECTIONS[@]} -eq 0 ]]; then
  test_pass "Shell CUSTOMIZATION.md has all required sections"
else
  test_fail "Shell CUSTOMIZATION.md missing sections: ${MISSING_SHELL_SECTIONS[*]}"
fi

# =============================================================================
# Test 10: UV Commands (Python)
# =============================================================================
run_test
log_info "Test 10: Checking Python CUSTOMIZATION.md UV command syntax..."
if grep -q "uv add" "$PYTHON_CUSTOM" && ! grep -q "uv pip install" "$PYTHON_CUSTOM"; then
  test_pass "Python CUSTOMIZATION.md uses correct UV commands"
else
  test_fail "Python CUSTOMIZATION.md has incorrect UV commands"
fi

# =============================================================================
# Test 11: Code Block Syntax
# =============================================================================
run_test
log_info "Test 11: Validating code block markers..."
PYTHON_BLOCKS=$(grep -c '```' "$PYTHON_CUSTOM" || true)
SHELL_BLOCKS=$(grep -c '```' "$SHELL_CUSTOM" || true)

if [[ $((PYTHON_BLOCKS % 2)) -eq 0 ]] && [[ $((SHELL_BLOCKS % 2)) -eq 0 ]]; then
  test_pass "All code blocks properly closed"
else
  test_fail "Unclosed code blocks detected"
fi

# =============================================================================
# Test 12: Checklist Format
# =============================================================================
run_test
log_info "Test 12: Verifying checklist format..."
PYTHON_CHECKLISTS=$(grep -c '\- \[ \]' "$PYTHON_CUSTOM" || true)
SHELL_CHECKLISTS=$(grep -c '\- \[ \]' "$SHELL_CUSTOM" || true)

if [[ $PYTHON_CHECKLISTS -gt 5 ]] && [[ $SHELL_CHECKLISTS -gt 5 ]]; then
  test_pass "Sufficient checklist items in documentation"
else
  test_fail "Insufficient checklist items (Python: $PYTHON_CHECKLISTS, Shell: $SHELL_CHECKLISTS)"
fi

# =============================================================================
# Test 13: Links to External Resources
# =============================================================================
run_test
log_info "Test 13: Checking external resource links..."
if grep -q "github.com/maxrantil/.github" "$PYTHON_CUSTOM" &&
  grep -q "github.com/maxrantil/.github" "$SHELL_CUSTOM"; then
  test_pass "Documentation links to reusable workflows repository"
else
  test_fail "Missing links to reusable workflows repository"
fi

# =============================================================================
# Test 14: Template Version Footer
# =============================================================================
run_test
log_info "Test 14: Verifying version footer..."
if grep -q "Template Version:" "$PYTHON_CUSTOM" &&
  grep -q "Last Updated:" "$PYTHON_CUSTOM" &&
  grep -q "Template Version:" "$SHELL_CUSTOM" &&
  grep -q "Last Updated:" "$SHELL_CUSTOM"; then
  test_pass "Both templates have version footer"
else
  test_fail "Missing version footer in templates"
fi

# =============================================================================
# Test 15: Workflow Customization Examples
# =============================================================================
run_test
log_info "Test 15: Checking workflow customization examples..."
if grep -q "python-version:" "$PYTHON_CUSTOM" &&
  grep -q "shellcheck-severity:" "$SHELL_CUSTOM"; then
  test_pass "Documentation includes workflow customization examples"
else
  test_fail "Missing workflow customization examples"
fi

# =============================================================================
# Test 16: Simulated Customization (Python)
# =============================================================================
run_test
log_info "Test 16: Simulating Python project customization..."

# Simulate updating pyproject.toml
sed -i 's/name = "python-project"/name = "my-test-project"/' "$PYTHON_DIR/pyproject.toml"
sed -i 's/description = ".*"/description = "A test project"/' "$PYTHON_DIR/pyproject.toml"

if grep -q 'name = "my-test-project"' "$PYTHON_DIR/pyproject.toml" &&
  grep -q 'description = "A test project"' "$PYTHON_DIR/pyproject.toml"; then
  test_pass "Python project metadata successfully customized"
else
  test_fail "Failed to customize Python project metadata"
fi

# =============================================================================
# Test 17: File Deletion Instructions
# =============================================================================
run_test
log_info "Test 17: Verifying cleanup instructions..."
if grep -q "Remove Template Files" "$PYTHON_CUSTOM" &&
  grep -q "CUSTOMIZATION.md" "$PYTHON_CUSTOM" &&
  grep -q "Remove Template Files" "$SHELL_CUSTOM" &&
  grep -q "CUSTOMIZATION.md" "$SHELL_CUSTOM"; then
  test_pass "Documentation includes cleanup instructions"
else
  test_fail "Missing cleanup instructions"
fi

# =============================================================================
# Summary
# =============================================================================
printf "\n"
echo "=========================================="
echo "Test Summary"
echo "=========================================="
echo "Tests run:    $TESTS_RUN"
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo "=========================================="

if [[ $TESTS_FAILED -eq 0 ]]; then
  log_info "All tests passed! ✓"
  exit 0
else
  log_error "$TESTS_FAILED test(s) failed"
  exit 1
fi
