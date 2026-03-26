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

strip_ansi() { echo "$1" | sed 's/\x1b\[[0-9;]*m//g'; }

left1=$(printf "\033[1;33m[%s]\033[0m | \033[1;36m%s\033[0m" "$model" "$dir_name")
[ -n "$branch" ] && left1="${left1} | ${branch}"

cols=$(tput cols 2>/dev/null || echo 80)
left1_plain=$(strip_ansi "$left1")
git_status_plain=$(strip_ansi "$git_status")
pad=$(( cols - ${#left1_plain} - ${#git_status_plain} ))
[ "$pad" -lt 1 ] && pad=1

printf "%s%${pad}s%s\n" "$left1" "" "$git_status"

ratelimit_str=""
if [ -n "$rate_five" ] && [ -n "$rate_seven" ]; then
  ratelimit_str=$(printf "\033[1;90m5h: %s%% / 7d: %s%%\033[0m" "$rate_five" "$rate_seven")
elif [ -n "$rate_five" ]; then
  ratelimit_str=$(printf "\033[1;90m5h: %s%%\033[0m" "$rate_five")
elif [ -n "$rate_seven" ]; then
  ratelimit_str=$(printf "\033[1;90m7d: %s%%\033[0m" "$rate_seven")
fi

if [ -n "$ratelimit_str" ]; then
  printf "%s | \033[1;90m%s\033[0m\n" "$ratelimit_str" "$duration"
else
  printf "\033[1;90m%s\033[0m\n" "$duration"
fi
