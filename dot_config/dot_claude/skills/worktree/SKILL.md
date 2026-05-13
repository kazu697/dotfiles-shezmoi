---
name: worktree
description: 状況に応じてgit worktreeを作成または既存のworktreeに移動する。新規ブランチが必要なとき（新機能開発・バグ修正の着手時）や、既存のworktreeへの移動、PRを分割する際にブランチを切る場合に使用する。
allowed-tools: Bash(git *), Bash(gtr *), ExitPlanMode
---

# Worktree

引数: $ARGUMENTS

## 適用条件

ファイルの編集・実装作業を開始する前は、必ずこのスキルでworktreeを作成または移動してから作業を開始する。

ただし、以下の場合はworktreeの作成をスキップしてそのまま作業を開始する:
- 現在すでに作業ブランチ（main/master以外のブランチ）にいる場合
- 現在すでにworktree内にいる場合（`git worktree list` でカレントディレクトリがworktreeとして確認できる場合）

## 手順

1. 現在の作業場所を確認する
   ```bash
   git branch --show-current
   git worktree list
   ```
   - 現在のブランチがmain/master以外、またはカレントディレクトリがworktreeであれば **手順2〜3をスキップ** してそのまま作業を開始する

2. 受け取った作業内容から、移動先を判断する
   - 引数に既存のブランチ名やパスが含まれる場合 → そのworktreeに移動
   - 新規作業の場合 → 以下のルールでブランチ名を生成する
     - 英語のkebab-case（例: `fix/user-auth`, `feat/add-payment`）
     - prefix は作業種別に応じて `feat/`, `fix/`, `chore/`, `refactor/` のいずれか
     - 単語は `-` で結合し、最大5単語以内

3. worktreeへの移動または作成
   - **既存のworktreeが存在する場合**:
     ```bash
     gtr go <branch>
     ```
   - **存在しない場合**:
     ```bash
     gtr new <branch>
     ```
     作成後、以下で移動する:
     ```bash
     gtr go <branch>
     ```

4. worktreeへの移動/作成が完了したら、`ExitPlanMode` を呼び出してプランモードを終了する
   - `prompt` パラメータには「worktree への移動が完了しました。ブランチ: {ブランチ名}。次の作業を開始してください。」のように作業内容とブランチ名を含める
