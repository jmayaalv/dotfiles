#!/usr/bin/env sh

# Click the cup to hold the Mac awake. The icon lights up while a caffeinate we
# started is running; it stays dim otherwise. Nothing is left behind on logout
# because the process dies with the session.
sketchybar --add       item     caffeine right                          \
           --set       caffeine update_freq=15                          \
                                icon=""                                \
                                icon.font="Hack Nerd Font:Regular:14.0" \
                                label.drawing=off                       \
                                script="$PLUGIN_DIR/caffeine.sh"        \
                                click_script="$PLUGIN_DIR/caffeine_click.sh" \
           --subscribe caffeine system_woke
