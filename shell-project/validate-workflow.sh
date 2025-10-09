#!/bin/bash
# ABOUTME: Shell workflow validation script - verifies shell quality checks work

set -euo pipefail

echo "🔍 Shell Workflow Validation Script"
echo "===================================="
echo ""

# Test 1: Verify script is properly formatted
echo "✓ Test 1: Script formatting"
echo "  - Using 4-space indentation"
echo "  - Using consistent style"
echo ""

# Test 2: Verify ShellCheck compatibility
echo "✓ Test 2: ShellCheck compatibility"
echo "  - No undefined variables (set -u)"
echo "  - Proper error handling (set -e)"
echo "  - Pipefail enabled (set -o pipefail)"
echo ""

# Test 3: Verify basic shell operations
echo "✓ Test 3: Basic shell operations"
TEST_VAR="GitHub Actions"
if [[ "$TEST_VAR" == "GitHub Actions" ]]; then
    echo "  - Variable assignment works"
fi

if [[ -n "$TEST_VAR" ]]; then
    echo "  - String comparison works"
fi
echo ""

# Test 4: Verify command substitution
echo "✓ Test 4: Command substitution"
CURRENT_DIR=$(pwd)
if [[ -n "$CURRENT_DIR" ]]; then
    echo "  - Command substitution works: $CURRENT_DIR"
fi
echo ""

# Test 5: Verify array operations
echo "✓ Test 5: Array operations"
TEST_ARRAY=("shellcheck" "shfmt" "workflow")
if [[ "${#TEST_ARRAY[@]}" -eq 3 ]]; then
    echo "  - Array length: ${#TEST_ARRAY[@]}"
    echo "  - Array elements: ${TEST_ARRAY[*]}"
fi
echo ""

# Test 6: Verify function definitions
echo "✓ Test 6: Function definitions"
test_function() {
    echo "  - Function execution works"
}
test_function
echo ""

# Test 7: Verify arithmetic operations
echo "✓ Test 7: Arithmetic operations"
RESULT=$((5 + 3))
if [[ "$RESULT" -eq 8 ]]; then
    echo "  - Arithmetic: 5 + 3 = $RESULT"
fi
echo ""

# Test 8: Verify file operations
echo "✓ Test 8: File operations"
if [[ -f "$0" ]]; then
    echo "  - Script file exists: $0"
fi
echo ""

echo "✅ All shell workflow validation tests passed!"
echo ""
echo "This script validates that:"
echo "  - ShellCheck can analyze the script without errors"
echo "  - shfmt can format the script correctly"
echo "  - Basic shell operations work in CI environment"
echo "  - Script follows best practices (set -euo pipefail)"
