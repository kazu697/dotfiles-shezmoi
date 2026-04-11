#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir_name=$(basename "$cwd")

branch=$(cd "$cwd" 2>/dev/null && starship module git_branch 2>/dev/null | tr -d '\n')
git_status=$(cd "$cwd" 2>/dev/null && starship module git_status 2>/dev/null | tr -d '\n')
git_file_count=$(cd "$cwd" 2>/dev/null && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')

rate_five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rate_seven=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

duration_ms=$(echo "$input" | jq -r '.cost.total_duration_ms // 0')
if [ "$duration_ms" -ge 60000 ]; then
  duration=$(awk "BEGIN {printf \"%.1fm\", $duration_ms/60000}")
else
  duration=$(awk "BEGIN {printf \"%.1fs\", $duration_ms/1000}")
fi

format_reset() {
  local resets_at="$1"
  [ -z "$resets_at" ] && return
  date -r "$resets_at" "+%H:%M" 2>/dev/null
}

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

  local filled_bar="" empty_bar=""
  for ((i=0; i<filled; i++)); do filled_bar+="█"; done
  for ((i=0; i<empty; i++)); do empty_bar+="░"; done
  printf "${color}%s\033[0;37m%s\033[0m" "$filled_bar" "$empty_bar"
}

# 1行目: [モデル名] | ディレクトリ名 | ブランチ名 git_status
line1=$(printf "\033[1;33m[%s]\033[0m | \033[1;36m%s\033[0m" "$model" "$dir_name")
if [ -n "$branch" ]; then
  git_info="${git_status}"
  [ "${git_file_count:-0}" -gt 0 ] && git_info="${git_info} $(printf '\033[0;37m%s\033[0m' "$git_file_count")"
  line1="${line1} | ${branch}${git_info}"
fi
printf "%s\n" "$line1"

# 2行目: rate_limitバー | 実行時間
line2=""
fmt_label() {
  local label="$1" resets_at="$2"
  local reset_str
  reset_str=$(format_reset "$resets_at")
  if [ -n "$reset_str" ]; then
    printf "\033[0;37m%s(%s)\033[0m" "$label" "$reset_str"
  else
    printf "\033[0;37m%s\033[0m" "$label"
  fi
}

[ -n "$rate_five" ]  && printf "$(make_bar "$rate_five") $(fmt_label "5h" "$rate_five_reset")\n"
[ -n "$rate_seven" ] && printf "$(make_bar "$rate_seven") $(fmt_label "7d" "$rate_seven_reset")\n"
printf "\033[0;37m%s\033[0m\n" "$duration"
