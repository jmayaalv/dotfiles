#!/usr/bin/env sh

# Tunnelblick VPN status. Sits immediately left of the clock.
# Label is off by default (icon colour carries the state); set label.drawing=on
# to show the connected configuration's name.
sketchybar --add       item vpn right                               \
           --set       vpn update_freq=10                           \
                           icon.font="Hack Nerd Font:Regular:15.0"  \
                           label.font="$FONT:Semibold:12.0"         \
                           label.color=$SUBTEXT0                    \
                           label.drawing=off                        \
                           script="$PLUGIN_DIR/vpn.sh"              \
                           click_script="open -a Tunnelblick"       \
           --subscribe vpn system_woke
