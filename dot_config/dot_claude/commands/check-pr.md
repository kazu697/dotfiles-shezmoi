---
description: 現在のブランチのPRを確認、なければdefaultブランチとの差分を表示
allowed-tools: Bash(git:*), Bash(gh:*)
---

# Check Current Branch PR or Show Diff

現在のブランチに関連するPRを確認し、存在しない場合はdefaultブランチとの差分を理解します。

以下の手順で実行してください：

1. 現在のブランチ名を取得
2. `gh pr list --head <current-branch>` で該当するPRを検索
3. PRが存在する場合：
   - `gh pr view` でPRの詳細を表示
   - `gh pr diff` で変更差分を表示
   - `gh pr checks` でCI/CDの状態を表示
4. PRが存在しない場合：
   - defaultブランチ（main）を取得
   - `git log main...HEAD` でコミット履歴を表示
   - `git diff main...HEAD` で変更差分を表示
   - ファイル変更の概要を理解して説明

最終的に、以下の情報を提供してください：
- PRの状態（存在する場合）またはブランチの状態
- 主な変更内容の要約
- レビューポイントや注意事項
