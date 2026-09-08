#!/usr/bin/env bash

# Left click fills the popup rows and toggles it; right click prints the full
# figures into a floating terminal.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
POPUP_ROWS=6

if [ "$BUTTON" = "right" ]; then
  sketchybar --set claude popup.drawing=off
  /Applications/Alacritty.app/Contents/MacOS/alacritty \
    --title "Claude usage" \
    --option 'window.dynamic_title=false' \
    --option 'window.startup_mode="Windowed"' \
    --option 'window.dimensions.columns=46' \
    --option 'window.dimensions.lines=16' \
    --command /bin/sh -c \
      "'$CONFIG_DIR/plugins/claude_usage.py' --detail; \
       printf '\n  [q or Enter] close  '; read -r _" &
  exit 0
fi

i=0
while IFS=$'\t' read -r left right; do
  [ "$i" -ge "$POPUP_ROWS" ] && break
  sketchybar --set "claude.row.$i" drawing=on icon="$left" label="$right"
  i=$((i + 1))
done < <("$CONFIG_DIR/plugins/claude_usage.py" --rows)

# Hide any slots left over from a previous, longer breakdown.
while [ "$i" -lt "$POPUP_ROWS" ]; do
  sketchybar --set "claude.row.$i" drawing=off
  i=$((i + 1))
done

sketchybar --set claude popup.drawing=toggle
