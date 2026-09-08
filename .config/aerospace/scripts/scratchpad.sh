#!/usr/bin/env bash
#
# Hyprland-style scratchpad for AeroSpace, which has no special workspace of its
# own. Workspace S is kept out of the 1-5 rotation and is only ever reached by
# toggling: press once to summon it, press again to return where you came from.
# Summoning an empty scratchpad spawns the dropdown terminal into it.
#
# Stashing a window into the scratchpad is a native binding, not this script:
# see SUPER+SHIFT+D in aerospace.toml.

set -uo pipefail

SCRATCH="${SCRATCH_WORKSPACE:-S}"
TERMINAL="/Applications/Alacritty.app"
TITLE="scratchpad"
# Where to return to. Remembered explicitly rather than leaning on AeroSpace's
# back-and-forth history: that history no-ops when the previous workspace is
# the scratchpad itself, which happens the moment you summon it twice - and
# leaves you trapped in it with no way back.
ORIGIN="${TMPDIR:-/tmp}/aerospace-scratchpad-origin"

current="$(aerospace list-workspaces --focused 2>/dev/null)"

if [ "$current" = "$SCRATCH" ]; then
  back="$(cat "$ORIGIN" 2>/dev/null || true)"
  case "$back" in
    "" | "$SCRATCH") back=1 ;;
  esac
  aerospace workspace "$back"
else
  printf '%s\n' "$current" > "$ORIGIN"
  aerospace workspace "$SCRATCH"
  # -n forces a new instance. Plain `open -a` would just activate the Alacritty
  # already running on another workspace and drag focus back out of the
  # scratchpad, which is exactly the bug this flag exists to avoid. A new window
  # opens on the focused workspace, which is now the scratchpad.
  if [ -z "$(aerospace list-windows --workspace "$SCRATCH" --format '%{window-id}' 2>/dev/null)" ]; then
    open -na "$TERMINAL" --args --title "$TITLE"
  fi
fi
