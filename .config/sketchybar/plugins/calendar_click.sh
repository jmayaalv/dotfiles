#!/usr/bin/env bash

# Left click opens Calendar, right click opens Date & Time settings.
# sketchybar supplies $BUTTON. Note that a sketchybar item is a single click
# target: the date (icon) and time (label) cannot be clicked separately.

if [ "$BUTTON" = "right" ]; then
  # Ventura+ pane id, with the pre-Ventura name as a fallback
  open "x-apple.systempreferences:com.apple.Date-Time-Settings.extension" 2>/dev/null \
    || open "x-apple.systempreferences:com.apple.preference.datetime"
else
  open -a Calendar
fi
