#!/usr/bin/env sh

# helper/clock.h sets this item's icon to the date and its label to the time,
# so both need to draw. update_freq only nudges the helper's routine sender.
sketchybar --add item     calendar right                    \
           --set calendar update_freq=15                    \
                          mach_helper="$HELPER"             \
                          icon.color=$BLACK                 \
                          icon.font="$FONT:Semibold:12.0"   \
                          icon.padding_left=8               \
                          icon.padding_right=4              \
                          label.color=$BLACK                \
                          label.font="$FONT:Heavy:12.0"     \
                          label.padding_left=4              \
                          label.padding_right=8             \
                          background.color=$SUBTEXT1        \
                          background.height=26              \
                          background.corner_radius=6
