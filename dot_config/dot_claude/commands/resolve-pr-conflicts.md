---
description: 現在のブランチのPRのマージコンフリクトを解消する
allowed-tools: Bash(git:*), Bash(git merge:*), Bash(gh:*)
---

# Resolve PR Merge Conflicts

現在のブランチのPRで発生しているマージコンフリクトを自動解消します。

## 実行手順

### 1. ワーキングツリーの確認

- `git status` で未コミットの変更がないか確認
- 未コミット変更がある場合は **処理を中断** し、ユーザーに通知

### 2. PR情報の取得

- `gh pr view --json number,title,baseRefName,headRefName,url,mergeable,mergeStateStatus` で PR 情報を取得
- PR が存在しない場合は終了
- `mergeable` / `mergeStateStatus` でコンフリクトの有無を判定
- コンフリクトがない場合はその旨を報告して終了

### 3. マージ実行前の確認

- ベースブランチ名、コンフリクトの状態をユーザーに表示
- AskUserQuestion でマージ実行の確認を取る

### 4. ベースブランチのマージ

- `git fetch origin <base-branch>`
- `git merge origin/<base-branch>`

### 5. コンフリクト解消

コンフリクトが発生した場合：

- `git diff --name-only --diff-filter=U` でコンフリクトファイル一覧を取得
- 各ファイルについて：
  - ファイル内容を読み取り、コンフリクトマーカーを確認
  - **バイナリファイル** の場合はユーザーに判断を委ねる
  - 両側の変更意図を理解し、適切にマージ
  - **どちらを採用すべきか判断できない場合** は、必ず AskUserQuestion で両方の変更内容を提示してユーザーに確認する。自信がないまま勝手に選択しないこと
  - **意味的に矛盾する変更**（同じ関数の異なるロジック変更など）がある場合も AskUserQuestion でユーザーに確認
- `git add <resolved-file>` で各ファイルをステージング

### 6. コミットとプッシュ

- `git commit` （デフォルトのマージコミットメッセージを使用）
- `git push`

### 7. 結果報告

以下の情報を報告：
- 解消したコンフリクトファイルの一覧
- 各ファイルの解消内容の要約
- PR の URL

## 安全策

- 未コミット変更がある場合は処理を中断する
- 問題が発生した場合は `git merge --abort` でロールバックする
- バイナリファイルのコンフリクトはユーザーに委ねる
- 意味的矛盾がある場合はユーザーに確認する
- どちらを採用すべきか判断に迷う場合は必ずユーザーに質問する
