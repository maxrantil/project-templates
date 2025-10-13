#!/usr/bin/env python3
"""Check commit message follows conventional commit format."""
import sys
import re

if len(sys.argv) < 2:
    print("ERROR: No commit message file provided")
    sys.exit(1)

with open(sys.argv[1]) as f:
    msg = f.read().strip()

pattern = r'^(feat|fix|docs|style|refactor|test|chore|perf|ci|build|revert)(\(.+\))?!?: .+'

if not re.match(pattern, msg):
    print('❌ ERROR: Commit message must use conventional commit format')
    print('')
    print('Format: <type>[optional scope]: <description>')
    print('')
    print('Examples:')
    print('  feat(template): add new project type')
    print('  fix(workflow): resolve validation issue')
    print('  docs: update template usage guide')
    print('')
    print('Types: feat, fix, docs, style, refactor, test, chore, perf, ci, build, revert')
    sys.exit(1)
