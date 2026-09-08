#!/usr/bin/env sh

# Claude Code quota widget. Everything shown is global: the two account-wide
# rate-limit windows and today's token spend across all sessions. Per-session
# figures (context window, this conversation's cost) are deliberately absent -
# they describe whichever conversation rendered last, which is meaningless in a
# bar shared by all of them.
#
# Popup rows use FiraCode Nerd Font Mono so the gauges and figures line up: the
# Mono variant forces Nerd Font icons to a single cell, and a fixed icon.width
# keeps every label starting at the same x regardless of its glyph.
CLAUDE_POPUP_ROWS=20
CLAUDE_MONO="FiraCode Nerd Font Mono"

sketchybar --add       item   claude right                                  \
           --set       claude update_freq=30                                \
                              icon=":claude:"                               \
                              icon.font="sketchybar-app-font:Regular:15.0"  \
                              icon.padding_left=10                          \
                              icon.padding_right=7                          \
                              label.font="$CLAUDE_MONO:Bold:12.0"           \
                              label.color=$TEXT                             \
                              label.padding_right=10                        \
                              popup.align=right                             \
                              popup.height=25                               \
                              script="$PLUGIN_DIR/claude.sh"                \
                              click_script="$PLUGIN_DIR/claude_click.sh"

i=0
while [ $i -lt $CLAUDE_POPUP_ROWS ]; do
  sketchybar --add item "claude.row.$i" popup.claude              \
             --set "claude.row.$i"                                \
                   drawing=off                                    \
                   icon.font="$CLAUDE_MONO:Regular:12.0"          \
                   icon.width=26                                  \
                   icon.padding_left=14                           \
                   icon.color=$OVERLAY1                           \
                   label.font="$CLAUDE_MONO:Regular:12.0"         \
                   label.color=$TEXT                              \
                   label.padding_right=16                         \
                   background.padding_left=0                      \
                   background.padding_right=0
  i=$((i + 1))
done
