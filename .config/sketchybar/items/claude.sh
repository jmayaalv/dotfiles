#!/usr/bin/env sh

# Claude Code quota widget. The bar shows the window closest to exhaustion
# (percent left plus a countdown to its reset); the popup breaks out both rate
# limit windows, context use, and today's token spend per model.
#
# Popup rows use a monospaced font so the ▰▱ gauges and figures line up - SF Pro
# is proportional and would ragged the columns.
CLAUDE_POPUP_ROWS=10
CLAUDE_MONO="FiraCode Nerd Font"

sketchybar --add       item   claude right                                  \
           --set       claude update_freq=30                                \
                              icon=":claude:"                               \
                              icon.font="sketchybar-app-font:Regular:15.0"  \
                              icon.padding_left=10                          \
                              icon.padding_right=6                          \
                              label.font="$CLAUDE_MONO:Bold:12.0"           \
                              label.color=$TEXT                             \
                              label.padding_right=10                        \
                              popup.align=right                             \
                              popup.height=24                               \
                              script="$PLUGIN_DIR/claude.sh"                \
                              click_script="$PLUGIN_DIR/claude_click.sh"

i=0
while [ $i -lt $CLAUDE_POPUP_ROWS ]; do
  sketchybar --add item "claude.row.$i" popup.claude              \
             --set "claude.row.$i"                                \
                   drawing=off                                    \
                   icon.font="$CLAUDE_MONO:Bold:12.0"             \
                   icon.color=$LAVENDER                           \
                   icon.padding_left=12                           \
                   icon.padding_right=8                           \
                   label.font="$CLAUDE_MONO:Regular:12.0"         \
                   label.color=$TEXT                              \
                   label.padding_right=12                         \
                   background.padding_left=0                      \
                   background.padding_right=0
  i=$((i + 1))
done
