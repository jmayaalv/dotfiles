#!/usr/bin/env bash

# Left click toggles the connection, right click opens Tunnelblick.
# sketchybar supplies $BUTTON and $NAME.

CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"

tb() { osascript -e "tell application \"Tunnelblick\" to $1" 2>/dev/null; }

if [ "$BUTTON" = "right" ]; then
  open -a Tunnelblick
  exit 0
fi

CONF="$(tb 'get name of first configuration')"
[ -z "$CONF" ] && { open -a Tunnelblick; exit 0; }   # not running yet

STATE="$(tb 'get state of first configuration')"
if [ "$STATE" = "CONNECTED" ]; then
  tb "disconnect \"$CONF\""
else
  tb "connect \"$CONF\""
fi

# Reflect the change without waiting for the next 10s poll. Connecting takes a
# few seconds, so refresh repeatedly - backgrounded so the click returns at once
# and cannot stall the bar.
(
  for _ in 1 2 3 4 5 6 7 8; do
    sleep 1
    NAME="$NAME" CONFIG_DIR="$CONFIG_DIR" "$CONFIG_DIR/plugins/vpn.sh"
  done
) >/dev/null 2>&1 &
disown
