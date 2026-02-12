---
description: Resolve merge conflicts in the PR for the current branch
allowed-tools: Bash(git:*), Bash(git merge:*), Bash(gh:*)
---

# Resolve PR Merge Conflicts

Automatically resolve merge conflicts in the PR for the current branch.

## Steps

### 1. Check Working Tree

- Run `git status` to check for uncommitted changes
- If uncommitted changes exist, **abort** and notify the user

### 2. Get PR Information

- Run `gh pr view --json number,title,baseRefName,headRefName,url,mergeable,mergeStateStatus` to get PR details
- If no PR exists, exit
- Check `mergeable` / `mergeStateStatus` to determine if conflicts exist
- If no conflicts, report that and exit

### 3. Confirm Before Merging

- Display the base branch name and conflict status to the user
- Use AskUserQuestion to confirm before proceeding with the merge

### 4. Merge Base Branch

- `git fetch origin <base-branch>`
- `git merge origin/<base-branch>`

### 5. Resolve Conflicts

When conflicts occur:

- Run `git diff --name-only --diff-filter=U` to list conflicted files
- For each file:
  - Read the file contents and identify conflict markers
  - For **binary files**, defer to the user
  - Understand the intent of both sides and merge appropriately
  - **If unsure which side to adopt**, always use AskUserQuestion to present both changes and ask the user. Never guess or pick a side without confidence
  - For **semantically contradictory changes** (e.g., different logic changes to the same function), also use AskUserQuestion to confirm with the user
- `git add <resolved-file>` to stage each resolved file

### 6. Commit and Push

- `git commit` (use the default merge commit message)
- `git push`

### 7. Report Results

Report the following:
- List of resolved conflict files
- Summary of how each conflict was resolved
- PR URL

## Safety

- Abort if uncommitted changes exist
- Run `git merge --abort` to rollback if something goes wrong
- Defer binary file conflicts to the user
- Ask the user when semantically contradictory changes are found
- Always ask the user when unsure which side to adopt
