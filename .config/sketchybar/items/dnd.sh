#!/usr/bin/env sh

# The moon reports whether a Focus is muting notifications: lit while one is on,
# dim otherwise. It is read-only. macOS ships no CLI or scriptable control for
# setting a Focus, and the Focus tile in Control Center carries no accessibility
# name to click, so the click opens the Focus settings pane rather than
# pretending to toggle.
sketchybar --add       item     dnd right                              \
           --set       dnd update_freq=5                               \
                           icon=""                                    \
                           icon.font="Hack Nerd Font:Regular:14.0"     \
                           label.drawing=off                           \
                           script="$PLUGIN_DIR/dnd.sh"                 \
                           click_script="$PLUGIN_DIR/dnd_click.sh"     \
           --subscribe dnd system_woke
