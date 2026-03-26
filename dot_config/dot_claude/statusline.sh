#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir_name=$(basename "$cwd")

branch=$(cd "$cwd" 2>/dev/null && starship module git_branch 2>/dev/null | tr -d '\n')
git_status=$(cd "$cwd" 2>/dev/null && starship module git_status 2>/dev/null | tr -d '\n')

rate_five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_seven=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
if [ "$duration_ms" -ge 60000 ]; then
  duration=$(awk "BEGIN {printf \"%.1fm\", $duration_ms/60000}")
else
  duration=$(awk "BEGIN {printf \"%.1fs\", $duration_ms/1000}")
fi

make_bar() {
  local pct="${1:-0}"
  local width=10
  local filled=$(( pct * width / 100 ))
  [ "$filled" -gt "$width" ] && filled=$width
  local empty=$(( width - filled ))

  if [ "$pct" -ge 90 ]; then
    color="\033[1;31m"
  elif [ "$pct" -ge 70 ]; then
    color="\033[1;33m"
  else
    color="\033[1;32m"
  fi

  local bar
  bar=$(printf '%0.s=' $(seq 1 "$filled") 2>/dev/null)
  bar="${bar}$(printf '%0.s ' $(seq 1 "$empty") 2>/dev/null)"
  printf "${color}[%s]\033[0m" "$bar"
}

# 1行目: [モデル名] | ディレクトリ名 | ブランチ名 git_status
line1=$(printf "\033[1;33m[%s]\033[0m | \033[1;36m%s\033[0m" "$model" "$dir_name")
if [ -n "$branch" ]; then
  line1="${line1} | ${branch}${git_status}"
fi
printf "%s\n" "$line1"

# 2行目: rate_limitバー | 実行時間
line2=""
if [ -n "$rate_five" ] && [ -n "$rate_seven" ]; then
  line2="$(make_bar "$rate_five") \033[1;90m5h\033[0m $(make_bar "$rate_seven") \033[1;90m7d\033[0m"
elif [ -n "$rate_five" ]; then
  line2="$(make_bar "$rate_five") \033[1;90m5h\033[0m"
elif [ -n "$rate_seven" ]; then
  line2="$(make_bar "$rate_seven") \033[1;90m7d\033[0m"
fi

if [ -n "$line2" ]; then
  printf "${line2} | \033[1;90m%s\033[0m\n" "$duration"
else
  printf "\033[1;90m%s\033[0m\n" "$duration"
fi
