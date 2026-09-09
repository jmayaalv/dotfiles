#!/usr/bin/env bash

# Draws the layout the focused window sits in. AeroSpace reports it directly:
#
#   $ aerospace list-windows --focused --format '%{window-layout}'
#   h_tiles          # also v_tiles, h_accordion, v_accordion, floating
#
# Fullscreen is a separate flag rather than a layout value, so it is asked for
# in the same call and wins over whatever the underlying layout is - that is
# the state you most need to know you are in.
#
# The glyph is the permanent state; the NAME appears only while the pointer is
# over the item, because six glyphs is more than anyone should have to memorise
# and a permanently visible label would cost the row width all day for a
# reminder needed once.

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

# TEXT, not NAME: $NAME is sketchybar's item name and must not be shadowed.
case "$LAYOUT" in
  h_tiles)     ICON=$LAYOUT_TILES_H;     COLOR=$ICON_COLOR; TEXT="tiles →" ;;
  v_tiles)     ICON=$LAYOUT_TILES_V;     COLOR=$ICON_COLOR; TEXT="tiles ↓" ;;
  h_accordion) ICON=$LAYOUT_ACCORDION_H; COLOR=$PEACH;      TEXT="accordion →" ;;
  v_accordion) ICON=$LAYOUT_ACCORDION_V; COLOR=$PEACH;      TEXT="accordion ↓" ;;
  floating)    ICON=$LAYOUT_FLOATING;    COLOR=$BLUE;       TEXT="floating" ;;
  # AeroSpace not answering (restarting, or not running yet). Dim rather than
  # blank, so the item keeps its width and the row does not jump.
  *)           ICON=$LAYOUT_TILES_H;     COLOR=$OVERLAY0;   TEXT="layout unknown" ;;
esac

if [ "$FULLSCREEN" = "true" ]; then
  ICON=$LAYOUT_FULLSCREEN
  COLOR=$RED
  TEXT="fullscreen"
fi

# The hover events OWN label.drawing, and nothing else may touch it: the 2s
# poll fires while the pointer is still resting on the item, so setting
# drawing=off on a routine update would blank the label mid-hover.
case "$SENDER" in
  mouse.entered) DRAW=(label.drawing=on) ;;
  mouse.exited)  DRAW=(label.drawing=off) ;;
  *)             DRAW=() ;;
esac

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$TEXT" "${DRAW[@]}"
