#!/bin/bash
# ABOUTME: Simple validation script for customization documentation

set -euo pipefail

echo "======================================"
echo "Customization Documentation Validation"
echo "======================================"
echo

# Get project root
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$PROJECT_ROOT"

TESTS_PASSED=0
TESTS_FAILED=0

test_check() {
  local name="$1"
  local command="$2"

  if eval "$command" > /dev/null 2>&1; then
    echo "✓ $name"
    ((TESTS_PASSED++))
  else
    echo "✗ $name"
    ((TESTS_FAILED++))
  fi
}

# Test 1: Files exist
echo "File Existence Tests:"
test_check "Python CUSTOMIZATION.md exists" "[[ -f python-project/CUSTOMIZATION.md ]]"
test_check "Shell CUSTOMIZATION.md exists" "[[ -f shell-project/CUSTOMIZATION.md ]]"
echo

# Test 2: Branch references
echo "Branch Reference Tests:"
test_check "Python doc uses @master" "grep -q '@master' python-project/CUSTOMIZATION.md"
test_check "Shell doc uses @master" "grep -q '@master' shell-project/CUSTOMIZATION.md"
test_check "Python doc doesn't use @main" "! grep -q '@main' python-project/CUSTOMIZATION.md"
test_check "Shell doc doesn't use @main" "! grep -q '@main' shell-project/CUSTOMIZATION.md"
echo

# Test 3: Essential sections
echo "Section Completeness Tests:"
test_check "Python has Quick Start" "grep -q 'Quick Start' python-project/CUSTOMIZATION.md"
test_check "Python has Troubleshooting" "grep -q 'Troubleshooting' python-project/CUSTOMIZATION.md"
test_check "Shell has Quick Start" "grep -q 'Quick Start' shell-project/CUSTOMIZATION.md"
test_check "Shell has Troubleshooting" "grep -q 'Troubleshooting' shell-project/CUSTOMIZATION.md"
echo

# Test 4: UV commands
echo "UV Command Tests:"
test_check "Python uses 'uv add'" "grep -q 'uv add' python-project/CUSTOMIZATION.md"
test_check "Python avoids 'uv pip install'" "! grep -q 'uv pip install' python-project/CUSTOMIZATION.md"
echo

# Test 5: Code blocks
echo "Code Block Tests:"
PYTHON_BLOCKS=$(grep -c '```' python-project/CUSTOMIZATION.md || echo 0)
SHELL_BLOCKS=$(grep -c '```' shell-project/CUSTOMIZATION.md || echo 0)
test_check "Python has code examples ($PYTHON_BLOCKS markers)" "[[ $PYTHON_BLOCKS -gt 20 ]]"
test_check "Shell has code examples ($SHELL_BLOCKS markers)" "[[ $SHELL_BLOCKS -gt 20 ]]"
test_check "Python code blocks balanced" "[[ $((PYTHON_BLOCKS % 2)) -eq 0 ]]"
test_check "Shell code blocks balanced" "[[ $((SHELL_BLOCKS % 2)) -eq 0 ]]"
echo

# Test 6: Referenced files exist
echo "Referenced File Tests:"
test_check "Python pyproject.toml exists" "[[ -f python-project/pyproject.toml ]]"
test_check "Python .pre-commit-config.yaml exists" "[[ -f python-project/.pre-commit-config.yaml ]]"
test_check "Shell .pre-commit-config.yaml exists" "[[ -f shell-project/.pre-commit-config.yaml ]]"
test_check "Python CI workflow exists" "[[ -f python-project/.github/workflows/ci.yml ]]"
test_check "Shell CI workflow exists" "[[ -f shell-project/.github/workflows/ci.yml ]]"
echo

# Test 7: Template copy simulation
echo "Template Copy Tests:"
TEMP_DIR=$(mktemp -d)
test_check "Can copy Python template" "cp -r python-project \"$TEMP_DIR/test-python\""
test_check "Can copy Shell template" "cp -r shell-project \"$TEMP_DIR/test-shell\""
test_check "Python copy is complete" "[[ -d \"$TEMP_DIR/test-python/.github\" ]]"
test_check "Shell copy is complete" "[[ -d \"$TEMP_DIR/test-shell/.github\" ]]"
rm -rf "$TEMP_DIR"
echo

# Test 8: Documentation quality
echo "Documentation Quality Tests:"
PYTHON_CHECKLISTS=$(grep -c '\- \[ \]' python-project/CUSTOMIZATION.md || echo 0)
SHELL_CHECKLISTS=$(grep -c '\- \[ \]' shell-project/CUSTOMIZATION.md || echo 0)
test_check "Python has checklists ($PYTHON_CHECKLISTS items)" "[[ $PYTHON_CHECKLISTS -gt 5 ]]"
test_check "Shell has checklists ($SHELL_CHECKLISTS items)" "[[ $SHELL_CHECKLISTS -gt 5 ]]"
test_check "Python has version footer" "grep -q 'Template Version:' python-project/CUSTOMIZATION.md"
test_check "Shell has version footer" "grep -q 'Template Version:' shell-project/CUSTOMIZATION.md"
echo

# Summary
echo "======================================"
echo "Summary"
echo "======================================"
echo "Tests passed: $TESTS_PASSED"
echo "Tests failed: $TESTS_FAILED"
echo "======================================"

if [[ $TESTS_FAILED -eq 0 ]]; then
  echo "✓ All validation tests passed!"
  exit 0
else
  echo "✗ Some tests failed"
  exit 1
fi
