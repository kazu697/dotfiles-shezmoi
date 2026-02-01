function cleanup-worktrees() {
    local MAIN_BRANCH="${1:-main}"
    local REMOTE="${2:-origin}"
    local DRY_RUN="${DRY_RUN:-false}"

    echo "=== リモートの最新情報を取得 ==="
    git fetch --prune "$REMOTE"

    echo "=== マージ済みworktreeの検索 (base: $REMOTE/$MAIN_BRANCH) ==="

    # メインworktree（.git直下）のパスを取得
    local MAIN_WORKTREE=$(git worktree list --porcelain | grep -m1 "^worktree " | cut -d' ' -f2)

    # リモートでマージ済みのブランチ一覧を取得（origin/feature/xxx → feature/xxx）
    local MERGED_REMOTE_BRANCHES=$(git branch -r --merged "$REMOTE/$MAIN_BRANCH" |
        sed 's/^[* ]*//' |
        grep "^$REMOTE/" |
        sed "s|^$REMOTE/||" |
        grep -v "^$MAIN_BRANCH$" |
        grep -v "^HEAD" || true)

    # worktree一覧をループ
    local WORKTREE_PATH=""
    git worktree list --porcelain | while read -r line; do
        if [[ "$line" == worktree* ]]; then
            WORKTREE_PATH="${line#worktree }"
        elif [[ "$line" == branch* ]]; then
            local BRANCH="${line#branch refs/heads/}"

            # メインworktreeはスキップ
            if [[ "$WORKTREE_PATH" == "$MAIN_WORKTREE" ]]; then
                continue
            fi

            # リモートでマージ済みか判定
            if echo "$MERGED_REMOTE_BRANCHES" | grep -qx "$BRANCH"; then
                echo "✓ リモートでマージ済み: $BRANCH ($WORKTREE_PATH)"
                if [[ "$DRY_RUN" == "true" ]]; then
                    echo "  [DRY RUN] git worktree remove $WORKTREE_PATH"
                else
                    git worktree remove "$WORKTREE_PATH" && echo "  削除完了"
                fi
            else
                echo "✗ 未マージ: $BRANCH ($WORKTREE_PATH)"
            fi
        fi
    done

    # pruneで不要な参照を削除
    if [[ "$DRY_RUN" != "true" ]]; then
        git worktree prune
        echo "=== worktree prune 完了 ==="
    fi
}
