#!/bin/bash
# WorktreeRemove hook: gtr rm か git worktree remove でworktreeを削除する

INPUT=$(cat)
WORKTREE_PATH=$(echo "$INPUT" | jq -r '.worktree_path')
BRANCH=$(basename "$WORKTREE_PATH")

if git -C "$WORKTREE_PATH" worktree list 2>/dev/null | grep -q "$WORKTREE_PATH"; then
  if git gtr rm "$BRANCH" --yes 2>/dev/null; then
    echo "worktreeを削除しました: $BRANCH" >&2
  else
    git worktree remove --force "$WORKTREE_PATH" 2>&1 >&2
  fi
fi
