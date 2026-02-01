---
description: Create a worktree from a Pull Request URL and work in that directory
allowed-tools: Bash(git:*), Bash(gh:*), Bash(gtr:*), Bash(cd:*), Read, Write, Edit, Glob, Grep
---

# PR Worktree: Worktree operations on PR branches

This command creates a worktree for the specified Pull Request branch using `gtr` and moves into that directory to perform work.

## Arguments

- `$ARGUMENTS`: Pull Request URL or PR number

## Execution Steps

### 1. Get PR Information

```bash
gh pr view $ARGUMENTS --json headRefName,baseRefName,title,number
```

- `headRefName`: PR branch name (used for worktree creation)
- `baseRefName`: Base branch name
- `title`: PR title
- `number`: PR number

### 2. Create Worktree

Create a worktree using the `gtr` command.

```bash
gtr new <headRefName>
```

If the worktree already exists, skip creation.

### 3. Move to Worktree Directory

```bash
cd "$(gtr go <headRefName>)"
```

**Important**: All subsequent commands should be executed in this worktree directory.

<h3> 4. Check Current State </h3>

After moving, check the following:

- `status` to check the worktree's status
- `log --oneline -5` to check the latest commits
- Understand the PR's changes

### 5. Perform Work According to User Instructions

If `$ARGUMENTS` contains additional instructions beyond a URL/number, perform work according to those instructions.

If there are no additional instructions, report the following and wait:

- Worktree path
- Current branch
- PR summary
- Ask "What would you like to do?"

## Usage Examples

```
/pr-worktree https://github.com/owner/repo/pull/123
/pr-worktree 123
/pr-worktree https://github.com/owner/repo/pull/123 Fix CI errors
```

## Notes

- The `gtr` command requires `git-worktree-runner` to be installed.
- Worktrees are created under `~/.gtr/worktrees/`.
- If you need to delete a worktree after completing your work, use `gtr rm <branch>`.
