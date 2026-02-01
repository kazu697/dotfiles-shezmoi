---
description: Pull RequestのURLからworktreeを作成し、そのディレクトリで作業を行う
allowed-tools: Bash(git:*), Bash(gh:*), Bash(gtr:*), Bash(cd:*), Read, Write, Edit, Glob, Grep
---

# PR Worktree: PRブランチでのworktree作業

指定されたPull RequestのブランチをgtrでWorktreeとして作成し、そのディレクトリに移動して作業を行います。

## 引数

- `$ARGUMENTS`: Pull RequestのURLまたはPR番号

## 実行手順

### 1. PR情報の取得

```bash
gh pr view $ARGUMENTS --json headRefName,baseRefName,title,number
```

- `headRefName`: PRのブランチ名（worktree作成に使用）
- `baseRefName`: ベースブランチ名
- `title`: PRタイトル
- `number`: PR番号

### 2. Worktreeの作成

gtrコマンドを使用してworktreeを作成します。

```bash
git gtr new <headRefName>
```

既にworktreeが存在する場合は作成をスキップします。

### 3. Worktreeディレクトリへの移動

```bash
cd "$(git gtr go <headRefName>)"
```

**重要**: 以降のすべてのコマンドはこのworktreeディレクトリで実行してください。

### 4. 現在の状態確認

移動後、以下を確認します：
- `git status` でworktreeの状態確認
- `git log --oneline -5` で最新コミット確認
- PRの変更内容を理解

### 5. ユーザー指示に従って作業

$ARGUMENTSにURL/番号以外の追加指示がある場合は、その指示に従って作業を実行します。

追加指示がない場合は、以下を報告して待機します：
- Worktreeのパス
- 現在のブランチ
- PRの概要
- 「何をしますか？」と確認

## 使用例

```
/pr-worktree https://github.com/owner/repo/pull/123
/pr-worktree 123
/pr-worktree https://github.com/owner/repo/pull/123 CIエラーを修正して
```

## 注意事項

- gtrコマンドはgit-worktree-runnerがインストールされている必要があります
- worktreeは `~/.gtr/worktrees/` 配下に作成されます
- 作業完了後、worktreeの削除が必要な場合は `git gtr rm <branch>` を使用
