#!/usr/bin/env bash

# Left click fills the popup and toggles it; right click opens the full table.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"
CLAUDE_POPUP_ROWS=20
USAGE="$CONFIG_DIR/plugins/claude_usage.py"

if [ "$BUTTON" = "right" ]; then
  sketchybar --set claude popup.drawing=off
  /Applications/Alacritty.app/Contents/MacOS/alacritty \
    --title "Claude usage" \
    --option 'window.dynamic_title=false' \
    --option 'window.startup_mode="Windowed"' \
    --option 'window.decorations="none"' \
    --option 'window.dimensions.columns=62' \
    --option 'window.dimensions.lines=22' \
    --option 'window.padding.x=14' \
    --option 'window.padding.y=10' \
    --option 'font.size=12' \
    --command /bin/sh -c "'$USAGE' --detail; printf '  [q or Enter] close  '; read -r _" &
  exit 0
fi

colour_for() {
  case "$1" in
    ok)     printf '%s' "$GREEN"    ;;
    warn)   printf '%s' "$YELLOW"   ;;
    hot)    printf '%s' "$PEACH"    ;;
    crit)   printf '%s' "$RED"      ;;
    accent) printf '%s' "$LAVENDER" ;;
    dim)    printf '%s' "$OVERLAY0" ;;
    *)      printf '%s' "$TEXT"     ;;
  esac
}

i=0
# \x1f rather than tab: a tab is IFS whitespace, so an empty icon field would be
# swallowed and every column would shift one to the left.
while IFS=$'\x1f' read -r icon label key; do
  [ "$i" -ge "$CLAUDE_POPUP_ROWS" ] && break
  col="$(colour_for "$key")"
  sketchybar --set "claude.row.$i" drawing=on          \
                                   icon="$icon"        \
                                   icon.color="$col"   \
                                   label="$label"      \
                                   label.color="$col"
  i=$((i + 1))
done < <("$USAGE" --rows)

while [ "$i" -lt "$CLAUDE_POPUP_ROWS" ]; do
  sketchybar --set "claude.row.$i" drawing=off
  i=$((i + 1))
done

sketchybar --set claude popup.drawing=toggle
