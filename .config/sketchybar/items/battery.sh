#!/usr/bin/env sh

sketchybar --add       item    battery right                          \
           --set       battery update_freq=120                        \
                               icon.font="Hack Nerd Font:Regular:14.0"         \
                               label.font="$FONT:Semibold:12.0"       \
                               script="$PLUGIN_DIR/battery.sh"        \
           --subscribe battery system_woke power_source_change
