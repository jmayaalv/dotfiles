#!/usr/bin/env bash

# Reflect whether any Focus is silencing notifications. macOS posts no event
# sketchybar can subscribe to, so this polls the file notificationd keeps:
# data.0.storeAssertionRecords holds one record per active assertion while a
# Focus is on, and the key is absent entirely when none is. Any Focus counts,
# not just Do Not Disturb - the question the moon answers is whether
# notifications are getting through, and a Work or Sleep mode mutes them too.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

DND_DB="${DND_DB:-$HOME/Library/DoNotDisturb/DB/Assertions.json}"

COUNT=$(plutil -extract data.0.storeAssertionRecords raw -o - "$DND_DB" 2>/dev/null)

if [[ "$COUNT" =~ ^[0-9]+$ ]] && ((COUNT > 0)); then
  COLOR=$MAUVE
else
  COLOR=$OVERLAY1
fi

sketchybar --animate sin 15 --set "${NAME:-dnd}" icon.color="$COLOR"
