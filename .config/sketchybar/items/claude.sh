#!/usr/bin/env sh

# Claude Code usage for today, read from the local session logs.
# Left click toggles a popup breakdown; right click opens the raw figures.
# POPUP_ROWS fixed slots are created up front and filled on click, which avoids
# adding and removing items on every open.
POPUP_ROWS=6

sketchybar --add       item   claude right                                  \
           --set       claude update_freq=60                                \
                              icon=":claude:"                               \
                              icon.font="sketchybar-app-font:Regular:15.0"  \
                              icon.color=$PEACH                             \
                              label.font="$FONT:Semibold:12.0"              \
                              label.color=$SUBTEXT0                         \
                              popup.align=right                             \
                              popup.height=26                               \
                              script="$PLUGIN_DIR/claude.sh"                \
                              click_script="$PLUGIN_DIR/claude_click.sh"

i=0
while [ $i -lt $POPUP_ROWS ]; do
  sketchybar --add item "claude.row.$i" popup.claude       \
             --set "claude.row.$i"                         \
                   drawing=off                             \
                   icon.font="$FONT:Semibold:12.0"         \
                   icon.color=$SUBTEXT1                    \
                   icon.padding_left=10                    \
                   label.font="$FONT:Heavy:12.0"           \
                   label.color=$TEXT                       \
                   label.padding_right=10                  \
                   background.padding_left=0               \
                   background.padding_right=0
  i=$((i + 1))
done
