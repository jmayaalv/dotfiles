#!/usr/bin/env sh

# Presentation mode: hide everything but the workspace indicators.
# Usage: raw.sh on|off

if [ "$1" = "on" ]; then
  sketchybar --set apple.logo drawing=off \
             --set '/cpu.*/' drawing=off \
             --set calendar icon.drawing=off \
             --set separator drawing=off \
             --set front_app drawing=off \
             --set volume drawing=off \
             --set battery drawing=off
else
  sketchybar --set apple.logo drawing=on \
             --set '/cpu.*/' drawing=on \
             --set calendar icon.drawing=on \
             --set separator drawing=on \
             --set front_app drawing=on \
             --set volume drawing=on \
             --set battery drawing=on
fi
