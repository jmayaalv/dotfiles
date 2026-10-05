#!/bin/sh
# Mute herdr-radar's sidebar colours to quiet Catppuccin Mocha tones, then have
# radar rewrite its managed sidebar block. radar hard-codes its palette in
# lib/palette.js with no setting for it, and a plugin update ships a fresh
# copy, so run this again after updating radar.
set -eu
PATH="/opt/homebrew/bin:/usr/local/bin:$PATH"
herdr=${HERDR_BIN_PATH:-herdr}
palette=$(ls -d "$HOME"/.config/herdr/plugins/github/hhdebb.herdr-radar-*/lib/palette.js | head -n 1)

python3 - "$palette" <<'EOF'
import sys

path = sys.argv[1]
src = open(path).read()
swaps = [
    ("claude: '#d97757'", "claude: '#c8a48f'"),   # working title + logo
    ("done: '#4c9a5a'", "done: '#8fb59a'"),
    ("blocked: '#c04a4a'", "blocked: '#d08a96'"),
    ("unknown: '#907aa9'", "unknown: '#8a83a3'"),
    ("idleFresh: '#95bba2'", "idleFresh: '#8a9a92'"),
    ("idleNormal: '#a99e92'", "idleNormal: '#8a8f9e'"),
    ("idleStale: '#8b8e9c'", "idleStale: '#6c7086'"),
    ("dark: '#e9e9f0'", "dark: '#bac2de'"),        # logo ink
]
for old, new in swaps:
    if new in src:
        continue
    if src.count(old) != 1:
        sys.exit(f"mute-palette: expected one {old!r} in {path}; radar changed, review the swaps")
    src = src.replace(old, new)
open(path, "w").write(src)
EOF

"$herdr" plugin action invoke hhdebb.herdr-radar.configure >/dev/null
"$herdr" server reload-config >/dev/null
echo "radar palette muted: $palette"
