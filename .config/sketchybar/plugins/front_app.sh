#!/usr/bin/env sh

# front_app_switched supplies the newly focused app's name in $INFO.
# https://felixkratz.github.io/SketchyBar/config/events

if [ "$SENDER" = "front_app_switched" ]; then
  ICON="$(sh "$CONFIG_DIR/plugins/icon_map.sh" "$INFO")"
  sketchybar --set "$NAME" icon="$ICON" label="$INFO"
fi
