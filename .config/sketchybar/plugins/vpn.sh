#!/usr/bin/env bash

source "$CONFIG_DIR/colors.sh"

# Tunnelblick launches its own bundled openvpn only while a configuration is
# connecting or connected, which is the cheapest reliable signal available
# without AppleScript (which would need an Automation permission grant and is
# far too slow for a bar plugin). utun interfaces are unusable here: Tailscale
# and NordVPN create their own, so utun presence cannot be attributed to
# Tunnelblick.
#
# NOTE: $NAME is the item name supplied by sketchybar - do not shadow it.

VPN_PID="$(pgrep -x openvpn 2>/dev/null | head -1)"

if [ -n "$VPN_PID" ]; then
  CMD="$(ps -o command= -p "$VPN_PID" 2>/dev/null)"
  # .../Tunnelblick/Users/<user>/<Config Name>.tblk/... -> "Config Name"
  CONF="$(printf '%s' "$CMD" | sed -n 's|.*/Users/[^/]*/\(.*\)\.tblk/.*|\1|p' | head -1)"
  ICON="󰖂"
  COLOR=$GREEN
  LABEL="${CONF:-connected}"
else
  ICON="󰖂"
  COLOR=$OVERLAY0
  LABEL="off"
fi

sketchybar --set "$NAME" icon="$ICON" icon.color="$COLOR" label="$LABEL"
