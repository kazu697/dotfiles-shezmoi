#!/bin/bash
input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "unknown"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // ""')
dir_name=$(basename "$cwd")

branch=$(cd "$cwd" 2>/dev/null && git branch --show-current 2>/dev/null)
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
  for ((i=0; i<filled; i++)); do filled_bar+="█"; done
  for ((i=0; i<empty; i++)); do empty_bar+="░"; done
  printf "${color}%s\033[0;37m%s\033[0m" "$filled_bar" "$empty_bar"
}

line1=$(printf "\033[1;33m[%s]\033[0m | \033[1;36m%s\033[0m" "$model" "$dir_name")
if [ -n "$branch" ]; then
  git_info="\033[0;32m${branch}\033[0m"
  [ "${git_staged:-0}" -gt 0 ] && git_info="${git_info} \033[0;32m+${git_staged}\033[0m"
  [ "${git_modified:-0}" -gt 0 ] && git_info="${git_info} \033[0;33m~${git_modified}\033[0m"
  line1="${line1} | ${git_info}"
fi
printf "%b\n" "$line1"

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

if [ -n "$ctx_pct" ]; then
  ctx_used=$(printf '%.0f' "$ctx_pct")
  ctx_left=$(( 100 - ctx_used ))
  bar=$(make_bar "$ctx_pct")
  printf "%s \033[0;37mctx %d%% / %d%%\033[0m\n" "$bar" "$ctx_used" "$ctx_left"
fi
if [ -n "$rate_five" ]; then
  five_used=$(printf '%.0f' "$rate_five")
  five_left=$(( 100 - five_used ))
  bar=$(make_bar "$rate_five")
  label=$(fmt_label "5h" "$rate_five_reset")
  printf "%s %s \033[0;37m%d%% / %d%%\033[0m\n" "$bar" "$label" "$five_used" "$five_left"
fi
if [ -n "$rate_seven" ]; then
  seven_used=$(printf '%.0f' "$rate_seven")
  seven_left=$(( 100 - seven_used ))
  bar=$(make_bar "$rate_seven")
  label=$(fmt_label "7d" "$rate_seven_reset" "%-m/%-d %H:%M")
  printf "%s %s \033[0;37m%d%% / %d%%\033[0m\n" "$bar" "$label" "$seven_used" "$seven_left"
fi
