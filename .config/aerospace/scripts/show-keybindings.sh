#!/usr/bin/env bash
# Show the AeroSpace keybinding cheatsheet in a small floating window.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TITLE="AeroSpace Keybindings"
ALACRITTY=/Applications/Alacritty.app/Contents/MacOS/alacritty

# Window size. The cheatsheet renders in two columns at >=108 columns and falls
# back to a single tall column below that. Tweak these three to taste.
COLS=106
LINES=38
FONT_SIZE=12

# alacritty.toml sets startup_mode = "Maximized", which overrides
# window.dimensions entirely - hence the explicit Windowed override here.
"$ALACRITTY" \
  --title "$TITLE" \
  --option 'window.startup_mode="Windowed"' \
  --option "window.dimensions.columns=$COLS" \
  --option "window.dimensions.lines=$LINES" \
  --option 'window.padding.x=12' \
  --option 'window.padding.y=8' \
  --option 'window.decorations="none"' \
  --option "font.size=$FONT_SIZE" \
  --command /bin/sh -c \
    "python3 '$SCRIPT_DIR/keybindings.py'; \
     printf '  \033[2m[q or Enter] close\033[0m  '; read -r _" &

# The on-window-detected title rule can miss when the title is not yet set at
# the moment AeroSpace first sees the window, so float it explicitly too.
for _ in $(seq 1 40); do
  WID=$(aerospace list-windows --all --format '%{window-id} %{window-title}' 2>/dev/null \
        | awk -v t="$TITLE" 'index($0, t) { print $1; exit }')
  if [ -n "$WID" ]; then
    aerospace layout floating --window-id "$WID" >/dev/null 2>&1
    break
  fi
  sleep 0.1
done

wait
