#!/usr/bin/env sh

sketchybar --add       item   volume right                          \
           --set       volume icon.font="Hack Nerd Font:Regular:14.0"         \
                              icon.color=$SKY                        \
                              label.font="$FONT:Semibold:12.0"       \
                              script="$PLUGIN_DIR/volume.sh"         \
           --subscribe volume volume_change
