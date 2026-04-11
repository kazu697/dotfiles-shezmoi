#!/bin/bash
# WorktreeCreate hook: gtr new でworktreeを作成し、そのパスを返す

set -e

INPUT=$(cat)
NAME=$(echo "$INPUT" | jq -r '.name')
CWD=$(echo "$INPUT" | jq -r '.cwd')

cd "$CWD"

git gtr new "$NAME" >&2

WORKTREE_PATH=$(git gtr go "$NAME")
echo "$WORKTREE_PATH"
