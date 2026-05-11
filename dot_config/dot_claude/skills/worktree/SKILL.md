---
name: worktree
description: 状況に応じてgit worktreeを作成または既存のworktreeに移動する。新規ブランチが必要なとき（新機能開発・バグ修正の着手時）や、既存のworktreeへの移動、PRを分割する際にブランチを切る場合に使用する。
allowed-tools: Bash, EnterWorktree
---

# Worktree

引数: $ARGUMENTS

## 手順

1. `git worktree list` を実行し、既存のworktreeを確認する

2. 受け取った作業内容から、移動先を判断する
   - 引数に既存のブランチ名やパスが含まれる場合 → そのworktreeに移動
   - 新規作業の場合 → 以下のルールでブランチ名を生成する
     - 英語のkebab-case（例: `fix/user-auth`, `feat/add-payment`）
     - prefix は作業種別に応じて `feat/`, `fix/`, `chore/`, `refactor/` のいずれか
     - 単語は `-` で結合し、最大5単語以内

3. worktreeへの移動または作成
   - **既存のworktreeが存在する場合**: `path` パラメータで `EnterWorktree` を呼び出して移動する
   - **存在しない場合**: `name` パラメータで `EnterWorktree` を呼び出して新規作成する

4. worktreeへの移動/作成が完了したら、作業内容とブランチ名をユーザーに伝える
