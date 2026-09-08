#!/usr/bin/env sh

# helper/clock.h sets this item's icon to the date and its label to the time,
# so both need to draw. update_freq only nudges the helper's routine sender.
#
# Transparent background, so the colours have to work against the bar itself:
# the date is dimmed and the time is full-brightness to keep the two apart.
sketchybar --add item     calendar right                    \
           --set calendar update_freq=15                    \
                          mach_helper="$HELPER"             \
                          icon.color=$SUBTEXT0              \
                          icon.font="$FONT:Semibold:12.0"   \
                          icon.padding_left=8               \
                          icon.padding_right=4              \
                          label.color=$TEXT                 \
                          label.font="$FONT:Heavy:12.0"     \
                          label.padding_left=4              \
                          label.padding_right=8             \
                          background.drawing=off
