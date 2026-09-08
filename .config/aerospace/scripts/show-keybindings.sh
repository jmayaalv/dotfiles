#!/usr/bin/env bash
# Show the AeroSpace keybinding cheatsheet in a floating, screen-centred window.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TITLE="AeroSpace Keybindings"
ALACRITTY=/Applications/Alacritty.app/Contents/MacOS/alacritty

# keybindings.py needs >=108 columns for its two-column layout; below that it
# falls back to a single 62-line column that will not fit on screen.
COLS=112
LINES=38
FONT_SIZE=12
PAD_X=12
PAD_Y=8

# NOTE ON PLACEMENT: the window cannot currently be centred. Alacritty's
# window.position is ignored on macOS (verified via both --option and a
# generated --config-file), AeroSpace has no command to place a floating
# window, and System Events cannot write the position because Alacritty
# reports its AX window title as "Alacritty" rather than the --title value,
# so the window cannot even be addressed reliably. macOS places it at a
# consistent spot, so it is at least repeatable rather than random.

# window.dynamic_title=false is essential: with it on, Alacritty briefly reports
# a default title, so AeroSpace's on-window-detected title rule misses and tiles
# the window into the workspace instead of floating it - which is what made the
# sheet appear at a third of the screen width, wherever the layout put it.
"$ALACRITTY" \
  --title "$TITLE" \
  --option 'window.dynamic_title=false' \
  --option 'window.startup_mode="Windowed"' \
  --option "window.dimensions.columns=$COLS" \
  --option "window.dimensions.lines=$LINES" \
  --option "window.padding.x=$PAD_X" \
  --option "window.padding.y=$PAD_Y" \
  --option 'window.decorations="none"' \
  --option "font.size=$FONT_SIZE" \
  --command /bin/sh -c \
    "python3 '$SCRIPT_DIR/keybindings.py'; \
     printf '  \033[2m[q or Enter] close\033[0m  '; read -r _" &

# Belt and braces: float it explicitly in case the title rule still misses.
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
