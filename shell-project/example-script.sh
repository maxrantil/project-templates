#!/bin/bash
# ABOUTME: Example shell script demonstrating best practices

set -euo pipefail

# Example function showing proper shell scripting patterns
main() {
    echo "Example script for shell-project template"
    echo "This demonstrates proper shell scripting practices:"
    echo ""

    # Example 1: Variable usage
    local project_name="shell-project"
    echo "1. Variable usage: $project_name"

    # Example 2: Conditional logic
    if [[ -n "$project_name" ]]; then
        echo "2. Conditional logic: Project name is set"
    fi

    # Example 3: Command substitution
    local current_date
    current_date=$(date +%Y-%m-%d)
    echo "3. Command substitution: Today is $current_date"

    # Example 4: Array operations
    local -a tools=("shellcheck" "shfmt" "bash")
    echo "4. Array operations: Tools count: ${#tools[@]}"

    # Example 5: Function return
    echo "5. Function execution: Complete"
}

# Execute main function
main "$@"
