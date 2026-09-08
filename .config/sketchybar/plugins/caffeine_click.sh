#!/usr/bin/env bash

# Toggle the hold, then repaint immediately rather than waiting for the next
# update_freq tick.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

HOLD="caffeinate -dis"

if pgrep -f "$HOLD" >/dev/null 2>&1; then
  pkill -f "$HOLD"
else
  nohup $HOLD >/dev/null 2>&1 &
fi

NAME=caffeine "$CONFIG_DIR/plugins/caffeine.sh"
