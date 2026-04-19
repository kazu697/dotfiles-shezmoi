---
description: 作業内容からブランチ名を生成してworktreeを作成する
allowed-tools: EnterWorktree
---

# Create Worktree

引数: $ARGUMENTS

## 手順

1. 受け取った作業内容から、以下のルールでブランチ名を生成する
   - 英語のkebab-case（例: `fix/user-auth`, `feat/add-payment`）
   - prefix は作業種別に応じて `feat/`, `fix/`, `chore/`, `refactor/` のいずれか
   - 単語は `-` で結合し、最大5単語以内

2. 生成したブランチ名を `name` として `EnterWorktree` ツールを呼び出す
   - これにより WorktreeCreate hook が発火し、`git gtr new` + `git gtr go` が実行される

3. worktreeへの移動が完了したら、作業内容とブランチ名をユーザーに伝える
