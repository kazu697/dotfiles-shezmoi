#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir_name=$(basename "$cwd")

branch=$(cd "$cwd" 2>/dev/null && starship module git_branch 2>/dev/null | tr -d '\n')
git_status=$(cd "$cwd" 2>/dev/null && starship module git_status 2>/dev/null | tr -d '\n')
git_staged=$(cd "$cwd" 2>/dev/null && git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
git_modified=$(cd "$cwd" 2>/dev/null && git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

ctx_pct=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
ctx_rem=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')

rate_five=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
rate_five_reset=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
rate_seven=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
rate_seven_reset=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')


format_reset() {
  local resets_at="$1" fmt="${2:-%H:%M}"
  [ -z "$resets_at" ] && return
  date -r "$resets_at" "+${fmt}" 2>/dev/null
}

make_bar() {
  local pct
  pct=$(printf '%.0f' "${1:-0}" 2>/dev/null || echo 0)
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
  for ((i=0; i<filled; i++)); do filled_bar+="▓"; done
  for ((i=0; i<empty; i++)); do empty_bar+="░"; done
  printf "${color}%s\033[0;37m%s\033[0m" "$filled_bar" "$empty_bar"
}

# 1行目: [モデル名] | ディレクトリ名 | ブランチ名 git_status
line1=$(printf "\033[1;33m[%s]\033[0m | \033[1;36m%s\033[0m" "$model" "$dir_name")
if [ -n "$branch" ]; then
  git_info="${git_status}"
  [ "${git_staged:-0}" -gt 0 ] && git_info="${git_info} $(printf '\033[1;32m+%s\033[0m' "$git_staged")"
  [ "${git_modified:-0}" -gt 0 ] && git_info="${git_info} $(printf '\033[1;33m~%s\033[0m' "$git_modified")"
  line1="${line1} | ${branch}${git_info}"
fi
printf "%s\n" "$line1"

fmt_label() {
  local label="$1" resets_at="$2" fmt="${3:-%H:%M}"
  local reset_str
  reset_str=$(format_reset "$resets_at" "$fmt")
  if [ -n "$reset_str" ]; then
    printf "\033[0;37m%s(%s)\033[0m" "$label" "$reset_str"
  else
    printf "\033[0;37m%s\033[0m" "$label"
  fi
}

# 2行目: ctx bar + % | 5h label + % | 7d label + %
ctx_used=$(printf '%.0f' "${ctx_pct:-0}")
bar=$(make_bar "${ctx_pct:-0}")
line2="${bar} \033[0;37m${ctx_used}%\033[0m"

if [ -n "$rate_five" ]; then
  five_used=$(printf '%.0f' "$rate_five")
  five_left=$(( 100 - five_used ))
  label=$(fmt_label "5h" "$rate_five_reset")
  line2="${line2} | ${label} \033[0;37m${five_used}% / ${five_left}%\033[0m"
fi
if [ -n "$rate_seven" ]; then
  seven_used=$(printf '%.0f' "$rate_seven")
  seven_left=$(( 100 - seven_used ))
  label=$(fmt_label "7d" "$rate_seven_reset" "%-m/%-d %H:%M")
  line2="${line2} | ${label} \033[0;37m${seven_used}% / ${seven_left}%\033[0m"
fi
printf "%b\n" "$line2"
