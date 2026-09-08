#!/usr/bin/env sh

sketchybar --add       item      front_app left                            \
           --set       front_app icon.font="sketchybar-app-font:Regular:16.0" \
                                 icon.color=$LAVENDER                      \
                                 label.font="$FONT:Heavy:13.0"             \
                                 label.color=$LAVENDER                     \
                                 script="$PLUGIN_DIR/front_app.sh"         \
           --subscribe front_app front_app_switched
