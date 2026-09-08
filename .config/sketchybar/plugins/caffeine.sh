#!/usr/bin/env bash

# Reflect whether our caffeinate is holding the Mac awake. The flags double as
# the marker we match on, so we never touch a caffeinate some other tool owns.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

HOLD="caffeinate -dis"

if pgrep -f "$HOLD" >/dev/null 2>&1; then
  COLOR=$YELLOW
else
  COLOR=$OVERLAY1
fi

sketchybar --animate sin 15 --set "${NAME:-caffeine}" icon.color="$COLOR"
