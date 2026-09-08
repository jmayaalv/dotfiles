#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Two-stage check, for cost. pgrep (~10ms) gates on Tunnelblick's bundled
# openvpn, which only runs while a configuration is connecting or connected.
# Only if one exists do we pay for AppleScript (~90ms) to get the exact state,
# which is the only way to tell CONNECTED from CONNECTING.
#
# utun interfaces are useless here: Tailscale and NordVPN create their own.
# NOTE: $NAME is the item name supplied by sketchybar - do not shadow it.

ICON="󰖂"

if pgrep -x openvpn >/dev/null 2>&1; then
  STATE="$(osascript -e 'tell application "Tunnelblick" to get state of first configuration' 2>/dev/null)"
  CONF="$(osascript -e 'tell application "Tunnelblick" to get name of first configuration' 2>/dev/null)"
  case "$STATE" in
    CONNECTED)            COLOR=$GREEN;  LABEL="${CONF:-on}" ;;
    EXITING|DISCONNECTED) COLOR=$OVERLAY0; LABEL="off" ;;
    "")                   COLOR=$GREEN;  LABEL="${CONF:-on}" ;;   # AppleScript unavailable
    *)                    COLOR=$YELLOW; LABEL="${STATE,,}" ;;    # AUTH, SLEEP, RECONNECTING...
  esac
else
  COLOR=$OVERLAY0
  LABEL="off"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL"
