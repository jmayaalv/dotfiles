#!/usr/bin/env bash

# Draws the layout the focused window sits in. AeroSpace reports it directly:
#
#   $ aerospace list-windows --focused --format '%{window-layout}'
#   h_tiles          # also v_tiles, h_accordion, v_accordion, floating
#
# Fullscreen is a separate flag rather than a layout value, so it is asked for
# in the same call and wins over whatever the underlying layout is - that is
# the state you most need to know you are in.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"
source "$CONFIG_DIR/icons.sh"

read -r LAYOUT FULLSCREEN <<< "$(aerospace list-windows --focused \
  --format '%{window-layout} %{window-is-fullscreen}' 2>/dev/null)"

# An empty workspace has no focused window to ask about. The root container's
# layout is the useful answer there: it is what the next window will land in.
if [ -z "$LAYOUT" ]; then
  LAYOUT="$(aerospace list-workspaces --focused \
    --format '%{workspace-root-container-layout}' 2>/dev/null)"
  FULLSCREEN=false
fi

case "$LAYOUT" in
  h_tiles)     ICON=$LAYOUT_TILES_H;     COLOR=$ICON_COLOR ;;
  v_tiles)     ICON=$LAYOUT_TILES_V;     COLOR=$ICON_COLOR ;;
  h_accordion) ICON=$LAYOUT_ACCORDION_H; COLOR=$PEACH ;;
  v_accordion) ICON=$LAYOUT_ACCORDION_V; COLOR=$PEACH ;;
  floating)    ICON=$LAYOUT_FLOATING;    COLOR=$BLUE ;;
  # AeroSpace not answering (restarting, or not running yet). Dim rather than
  # blank, so the item keeps its width and the row does not jump.
  *)           ICON=$LAYOUT_TILES_H;     COLOR=$OVERLAY0 ;;
esac

if [ "$FULLSCREEN" = "true" ]; then
  ICON=$LAYOUT_FULLSCREEN
  COLOR=$RED
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR"
