#!/usr/bin/env bash

# Bar label plus an icon colour graded by how close the tightest rate-limit
# window is to exhaustion.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
source "$CONFIG_DIR/colors.sh"

USAGE="$CONFIG_DIR/plugins/claude_usage.py"
LABEL="$("$USAGE" --bar)"
USED="$("$USAGE" --severity)"

if   [ "$USED" -ge 90 ]; then COLOR=$RED
elif [ "$USED" -ge 70 ]; then COLOR=$PEACH
elif [ "$USED" -ge 50 ]; then COLOR=$YELLOW
else                          COLOR=$GREEN
fi

# Ease between severity colours so the widget never snaps from green to red.
sketchybar --animate sin 20 --set "$NAME" label="$LABEL" icon.color="$COLOR"
