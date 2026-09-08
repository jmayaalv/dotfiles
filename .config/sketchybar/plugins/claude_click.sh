#!/usr/bin/env bash

# Left click fills the popup and toggles it; right click opens the full table.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"
CLAUDE_POPUP_ROWS=10
USAGE="$CONFIG_DIR/plugins/claude_usage.py"

if [ "$BUTTON" = "right" ]; then
  sketchybar --set claude popup.drawing=off
  /Applications/Alacritty.app/Contents/MacOS/alacritty \
    --title "Claude usage" \
    --option 'window.dynamic_title=false' \
    --option 'window.startup_mode="Windowed"' \
    --option 'window.decorations="none"' \
    --option 'window.dimensions.columns=58' \
    --option 'window.dimensions.lines=22' \
    --option 'window.padding.x=12' \
    --option 'font.size=12' \
    --command /bin/sh -c "'$USAGE' --detail; printf '  [q or Enter] close  '; read -r _" &
  exit 0
fi

i=0
while IFS=$'\t' read -r left right; do
  [ "$i" -ge "$CLAUDE_POPUP_ROWS" ] && break
  # A row with no left label is a spacer or a footnote: dim it and drop the gap.
  if [ -z "$left" ]; then
    sketchybar --set "claude.row.$i" drawing=on icon="" label="$right" \
                                     label.color="$OVERLAY1"
  else
    sketchybar --set "claude.row.$i" drawing=on icon="$left" label="$right" \
                                     label.color="$TEXT"
  fi
  i=$((i + 1))
done < <("$USAGE" --rows)

while [ "$i" -lt "$CLAUDE_POPUP_ROWS" ]; do
  sketchybar --set "claude.row.$i" drawing=off
  i=$((i + 1))
done

sketchybar --set claude popup.drawing=toggle
