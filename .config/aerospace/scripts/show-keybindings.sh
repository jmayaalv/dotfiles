#!/usr/bin/env bash
# Open the keybinding cheatsheet in a small floating Alacritty window.
# aerospace.toml floats and centers it by matching the window title.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TITLE="AeroSpace Keybindings"

exec /Applications/Alacritty.app/Contents/MacOS/alacritty \
  --title "$TITLE" \
  --option 'window.dimensions.columns=54' \
  --option 'window.dimensions.lines=46' \
  --option 'window.padding.x=14' \
  --option 'window.padding.y=10' \
  --command /bin/sh -c "python3 '$SCRIPT_DIR/keybindings.py'; \
    printf '  \033[2m[q or Enter] close\033[0m  '; read -r _"
