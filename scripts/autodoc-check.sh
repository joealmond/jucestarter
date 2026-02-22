#!/bin/bash

# autodoc-check.sh
# Called by VS Code agent Stop hook.
# Checks if code was modified but docs weren't updated.
# Instead of blocking, it tells the agent to fix the problem.

# Read hook input from stdin
INPUT=$(cat)

# Check if stop_hook_active to prevent infinite loops
STOP_ACTIVE=$(echo "$INPUT" | grep -o '"stop_hook_active": *true' || true)
if [ -n "$STOP_ACTIVE" ]; then
  # Already ran once — don't loop
  echo '{"continue": true}'
  exit 0
fi

# Get list of modified files in the working tree (staged + unstaged)
CHANGED_FILES=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || echo "")

if [ -z "$CHANGED_FILES" ]; then
  # No changes — nothing to check
  echo '{"continue": true}'
  exit 0
fi

# Check if any source/code files were modified (not just docs/config)
CODE_CHANGED=$(echo "$CHANGED_FILES" | grep -v -E '^(docs/|templates/|\.github/|AGENTS\.md|CHANGELOG|ROADMAP|README)' || true)

if [ -z "$CODE_CHANGED" ]; then
  # Only docs/config changed — that's fine
  echo '{"continue": true}'
  exit 0
fi

# Check if CHANGELOG was also updated
CHANGELOG_UPDATED=$(echo "$CHANGED_FILES" | grep -q "CHANGELOG" && echo "yes" || echo "no")

if [ "$CHANGELOG_UPDATED" = "yes" ]; then
  # Code changed AND changelog updated — all good
  echo '{"continue": true}'
  exit 0
fi

# Code changed but no CHANGELOG update — ask the agent to fix it
cat << 'EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "Stop",
    "decision": "block",
    "reason": "You modified code files but didn't update CHANGELOG.md. Please add a changelog entry describing what was changed, then you can finish."
  }
}
EOF
exit 0
