#!/usr/bin/env bash
# Claude Code status line script
# Displays: model, cwd, context tokens remaining, 5-hour window, 7-day window

input=$(cat)

model=$(echo "$input" | jq -r '.model.display_name // "Claude"')
cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""')
cwd_short=$(echo "$cwd" | sed "s|$HOME|~|")

remaining=$(echo "$input" | jq -r '.context_window.remaining_percentage // empty')
five_hour=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
five_hour_resets=$(echo "$input" | jq -r '.rate_limits.five_hour.resets_at // empty')
seven_day=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')
seven_day_resets=$(echo "$input" | jq -r '.rate_limits.seven_day.resets_at // empty')

parts=()

# Git branch
git_branch=$(git -C "$cwd" rev-parse --abbrev-ref HEAD 2>/dev/null)

# Model + cwd + branch
if [ -n "$git_branch" ]; then
  parts+=("$(printf '\033[0;36m%s\033[0m' "$model") $(printf '\033[0;33m%s\033[0m' "$cwd_short") $(printf '\033[0;35m⎇ %s\033[0m' "$git_branch")")
else
  parts+=("$(printf '\033[0;36m%s\033[0m' "$model") $(printf '\033[0;33m%s\033[0m' "$cwd_short")")
fi

# Context tokens remaining
if [ -n "$remaining" ]; then
  remaining_int=$(printf '%.0f' "$remaining")
  if [ "$remaining_int" -le 10 ]; then
    color='\033[0;31m'  # red
  elif [ "$remaining_int" -le 25 ]; then
    color='\033[0;33m'  # yellow
  else
    color='\033[0;32m'  # green
  fi
  parts+=("$(printf "ctx:${color}%d%%\033[0m" "$remaining_int") left")
fi

# 5-hour window used + reset time
if [ -n "$five_hour" ]; then
  five_int=$(printf '%.0f' "$five_hour")
  if [ "$five_int" -ge 90 ]; then
    color='\033[0;31m'
  elif [ "$five_int" -ge 70 ]; then
    color='\033[0;33m'
  else
    color='\033[0;32m'
  fi
  five_label="$(printf "5h:${color}%d%%\033[0m" "$five_int") used"
  if [ -n "$five_hour_resets" ]; then
    reset_time=$(date -r "$five_hour_resets" "+%H:%M" 2>/dev/null)
    [ -n "$reset_time" ] && five_label="$five_label $(printf '\033[0;37m(resets %s)\033[0m' "$reset_time")"
  fi
  parts+=("$five_label")
fi

# 7-day window used + reset time
if [ -n "$seven_day" ]; then
  seven_int=$(printf '%.0f' "$seven_day")
  if [ "$seven_int" -ge 90 ]; then
    color='\033[0;31m'
  elif [ "$seven_int" -ge 70 ]; then
    color='\033[0;33m'
  else
    color='\033[0;32m'
  fi
  seven_label="$(printf "7d:${color}%d%%\033[0m" "$seven_int") used"
  if [ -n "$seven_day_resets" ]; then
    reset_time=$(date -r "$seven_day_resets" "+%a %H:%M" 2>/dev/null)
    [ -n "$reset_time" ] && seven_label="$seven_label $(printf '\033[0;37m(resets %s)\033[0m' "$reset_time")"
  fi
  parts+=("$seven_label")
fi

# Join parts with separator
printf '%s' "${parts[0]}"
for part in "${parts[@]:1}"; do
  printf ' | %s' "$part"
done
printf '\n'
