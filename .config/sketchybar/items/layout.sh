#!/usr/bin/env sh

# The layout of the focused window, as one glyph. Sits between the workspace
# strip and the front app: workspaces say where you are, this says how it is
# arranged, the app name says what is in front.
#
# AeroSpace has no on-layout-change callback, so the item is driven four ways:
#   - aerospace_layout_change, triggered by the layout bindings themselves
#     (aerospace.toml) - this is what makes SUPER+J feel instant
#   - aerospace_workspace_change, since each workspace has its own layout
#   - front_app_switched, which covers focus moving between apps
#   - update_freq, the backstop for the one case none of those catch: focus
#     moving between sibling windows (SUPER+A/S/W/D) fires no event at all
#
# It also subscribes to mouse.entered/exited, which is what reveals the layout's
# NAME while the pointer rests on it - the glyph alone is not memorable.
sketchybar --add event aerospace_layout_change

sketchybar --add       item   layout left                                    \
           --set       layout update_freq=2                                  \
                              icon.font="$FONT:Regular:15.0"                 \
                              icon.color=$ICON_COLOR                         \
                              label.font="$FONT:Semibold:12.0"               \
                              label.color=$SUBTEXT0                          \
                              label.drawing=off                              \
                              script="$PLUGIN_DIR/layout.sh"                 \
                              click_script="aerospace layout tiles horizontal vertical; sketchybar --trigger aerospace_layout_change" \
           --subscribe layout aerospace_layout_change                        \
                              aerospace_workspace_change                     \
                              front_app_switched                             \
                              mouse.entered                                  \
                              mouse.exited
