#!/usr/bin/env bash

# Bar label: today's total tokens and estimated cost.
CONFIG_DIR="${CONFIG_DIR:-$HOME/.config/sketchybar}"
sketchybar --set "$NAME" label="$("$CONFIG_DIR/plugins/claude_usage.py" --bar)"
