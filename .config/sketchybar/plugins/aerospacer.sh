#!/usr/bin/env bash

# Called as: aerospacer.sh <workspace-id>
# Highlights the workspace if it is the focused one, and labels it with a glyph
# per running app (sketchybar-app-font ligatures, via icon_map.sh).

SID="$1"
[ -z "$SID" ] && exit 0

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

# aerospace_workspace_change supplies FOCUSED_WORKSPACE; the initial forced
# update does not, so ask aerospace directly in that case.
FOCUSED="$FOCUSED_WORKSPACE"
[ -z "$FOCUSED" ] && FOCUSED="$(aerospace list-workspaces --focused)"

if [ "$SID" = "$FOCUSED" ]; then
  sketchybar --set "$NAME" background.drawing=on icon.highlight=on
else
  sketchybar --set "$NAME" background.drawing=off icon.highlight=off
fi

# Build the app-glyph label for this workspace
apps="$(aerospace list-windows --workspace "$SID" --format '%{app-name}' 2>/dev/null | sort -u)"

icons=""
while IFS= read -r app; do
  [ -z "$app" ] && continue
  icons+="$(sh "$CONFIG_DIR/plugins/icon_map.sh" "$app")"
done <<< "$apps"

if [ -n "$icons" ]; then
  sketchybar --set "$NAME" label="$icons" label.drawing=on
else
  sketchybar --set "$NAME" label.drawing=off
fi
