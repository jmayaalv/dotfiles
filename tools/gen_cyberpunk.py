#!/usr/bin/env python3
"""Generate a cyberpunk / synthwave wallpaper in the Catppuccin Mocha palette.

Emits SVG to stdout; render with rsvg-convert. Deterministic via a fixed seed.
"""
import random
import sys

W, H = 3456, 2170
HY = 1240          # horizon line
CX = W // 2

# Catppuccin Mocha
BG        = "#1e1e2e"
BG_DARK   = "#161622"
BG_DARKER = "#101019"
BLUE      = "#89b4fa"
CYAN      = "#94e2d5"
MAGENTA   = "#f5c2e7"
PINK      = "#f38ba8"
YELLOW    = "#f9e2af"
ORANGE    = "#f6b6ab"
GREEN     = "#a6e3a1"

seed = int(sys.argv[1]) if len(sys.argv) > 1 else 7
rnd = random.Random(seed)
out = []
A = out.append


def glow_line(x1, y1, x2, y2, color, passes):
    """Neon line drawn as stacked strokes — cheaper and more portable than a blur filter."""
    for width, opacity in passes:
        A(f'<line x1="{x1:.1f}" y1="{y1:.1f}" x2="{x2:.1f}" y2="{y2:.1f}" '
          f'stroke="{color}" stroke-width="{width}" opacity="{opacity}" stroke-linecap="round"/>')


A(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">')

# ---------------------------------------------------------------- definitions
A('<defs>')
A(f'''<linearGradient id="sky" x1="0" y1="0" x2="0" y2="1">
  <stop offset="0%"   stop-color="#07070d"/>
  <stop offset="30%"  stop-color="{BG_DARKER}"/>
  <stop offset="62%"  stop-color="#241f38"/>
  <stop offset="85%"  stop-color="#3d2a4d"/>
  <stop offset="100%" stop-color="#5c3355"/>
</linearGradient>''')

A(f'''<linearGradient id="sun" x1="0" y1="0" x2="0" y2="1">
  <stop offset="0%"   stop-color="{YELLOW}"/>
  <stop offset="35%"  stop-color="{ORANGE}"/>
  <stop offset="68%"  stop-color="{PINK}"/>
  <stop offset="100%" stop-color="{MAGENTA}"/>
</linearGradient>''')

A(f'''<radialGradient id="sunhaze" cx="50%" cy="50%" r="50%">
  <stop offset="0%"   stop-color="{PINK}" stop-opacity="0.42"/>
  <stop offset="45%"  stop-color="{MAGENTA}" stop-opacity="0.15"/>
  <stop offset="100%" stop-color="{MAGENTA}" stop-opacity="0"/>
</radialGradient>''')

A(f'''<linearGradient id="ground" x1="0" y1="0" x2="0" y2="1">
  <stop offset="0%"   stop-color="#1a1428"/>
  <stop offset="35%"  stop-color="{BG_DARKER}"/>
  <stop offset="100%" stop-color="#06060b"/>
</linearGradient>''')

# Sun mask: white disc cut by black horizontal slits
A('<mask id="sunmask">')
A(f'<rect x="0" y="0" width="{W}" height="{H}" fill="black"/>')
A(f'<circle cx="{CX}" cy="1150" r="430" fill="white"/>')
y, i = 890.0, 0
while y < HY + 30:
    h = 4 + i * 2.3
    A(f'<rect x="{CX-460}" y="{y:.1f}" width="920" height="{h:.1f}" fill="black"/>')
    y += h + max(9, 52 - i * 2.6)
    i += 1
A('</mask>')

# Reflection of the sun on the ground plane. Radial, so it has no hard edges —
# a linear gradient in a rect leaves visible vertical seams against the grid.
A(f'''<radialGradient id="reflect" cx="50%" cy="0%" r="75%">
  <stop offset="0%"   stop-color="{MAGENTA}" stop-opacity="0.34"/>
  <stop offset="40%"  stop-color="{PINK}" stop-opacity="0.11"/>
  <stop offset="100%" stop-color="{PINK}" stop-opacity="0"/>
</radialGradient>''')

A(f'<clipPath id="belowhorizon"><rect x="0" y="{HY}" width="{W}" height="{H-HY}"/></clipPath>')

A('<pattern id="scan" width="4" height="4" patternUnits="userSpaceOnUse">'
  '<rect x="0" y="0" width="4" height="2" fill="#000000" opacity="0.10"/></pattern>')

A(f'''<radialGradient id="vignette" cx="50%" cy="48%" r="72%">
  <stop offset="0%"   stop-color="#000000" stop-opacity="0"/>
  <stop offset="62%"  stop-color="#000000" stop-opacity="0"/>
  <stop offset="100%" stop-color="#000000" stop-opacity="0.55"/>
</radialGradient>''')
A('</defs>')

# ------------------------------------------------------------------- sky
A(f'<rect x="0" y="0" width="{W}" height="{HY}" fill="url(#sky)"/>')

# stars, thinning out toward the horizon haze
for _ in range(520):
    sx = rnd.uniform(0, W)
    sy = rnd.uniform(0, HY - 180)
    depth = 1 - (sy / (HY - 180))
    r = rnd.uniform(0.8, 2.6)
    op = rnd.uniform(0.15, 0.85) * (0.35 + 0.65 * depth)
    col = rnd.choice([("#ffffff", 6), (CYAN, 2), (BLUE, 2), (MAGENTA, 1)])[0]
    A(f'<circle cx="{sx:.1f}" cy="{sy:.1f}" r="{r:.2f}" fill="{col}" opacity="{op:.2f}"/>')

# sun haze, then the slitted sun disc
A(f'<ellipse cx="{CX}" cy="1150" rx="1150" ry="760" fill="url(#sunhaze)"/>')
A(f'<g mask="url(#sunmask)"><rect x="{CX-460}" y="700" width="920" height="{HY-700}" fill="url(#sun)"/></g>')

# ------------------------------------------------------- distant skyline (hazy)
A('<g opacity="0.82">')
x = -60.0
while x < W + 60:
    bw = rnd.uniform(50, 130)
    bh = rnd.uniform(70, 260)
    # keep the far range low across the sun too, or it veils the disc in grey
    if abs(x + bw / 2 - CX) < 500:
        bh = min(bh, 105)
    A(f'<rect x="{x:.1f}" y="{HY-bh:.1f}" width="{bw:.1f}" height="{bh:.1f}" fill="#1d1834"/>')
    x += bw + rnd.uniform(6, 26)
A('</g>')

# --------------------------------------------------------- near skyline + neon
A('<g>')
buildings = []
x = -80.0
while x < W + 80:
    bw = rnd.uniform(70, 185)
    bh = rnd.uniform(120, 430)
    # keep a notch of low buildings around the sun so the slitted disc stays readable
    if abs(x + bw / 2 - CX) < 470:
        bh = min(bh, 125)
    buildings.append((x, bw, bh))
    A(f'<rect x="{x:.1f}" y="{HY-bh:.1f}" width="{bw:.1f}" height="{bh:.1f}" fill="#0d0b16"/>')
    x += bw + rnd.uniform(8, 34)
A('</g>')

# lit windows
neon = [CYAN, BLUE, MAGENTA, PINK, YELLOW]
A('<g>')
for bx, bw, bh in buildings:
    cols = max(1, int(bw // 22))
    rows = max(1, int(bh // 26))
    for c in range(cols):
        for r_ in range(rows):
            if rnd.random() > 0.30:
                continue
            wx = bx + 9 + c * 22
            wy = HY - bh + 12 + r_ * 26
            if wx + 7 > bx + bw - 4 or wy < HY - bh + 6:
                continue
            col = rnd.choice(neon)
            A(f'<rect x="{wx:.1f}" y="{wy:.1f}" width="7" height="11" fill="{col}" '
              f'opacity="{rnd.uniform(0.30, 0.95):.2f}"/>')
A('</g>')

# antennas with blinking red lamps
for bx, bw, bh in buildings:
    if bh < 300 or rnd.random() > 0.45:
        continue
    ax = bx + bw / 2
    top = HY - bh
    A(f'<line x1="{ax:.1f}" y1="{top:.1f}" x2="{ax:.1f}" y2="{top-rnd.uniform(40,110):.1f}" '
      f'stroke="#0d0b16" stroke-width="3"/>')
    A(f'<circle cx="{ax:.1f}" cy="{top-46:.1f}" r="4" fill="{PINK}" opacity="0.9"/>')
    A(f'<circle cx="{ax:.1f}" cy="{top-46:.1f}" r="11" fill="{PINK}" opacity="0.16"/>')

# vertical neon sign strips on a few facades
for bx, bw, bh in buildings:
    if bh < 220 or rnd.random() > 0.22:
        continue
    col = rnd.choice([MAGENTA, CYAN, PINK])
    sx = bx + rnd.uniform(10, max(11, bw - 18))
    y0 = HY - bh + rnd.uniform(20, 60)
    y1 = y0 + rnd.uniform(70, min(200, bh - 40))
    glow_line(sx, y0, sx, y1, col, [(9, 0.07), (4.5, 0.16), (1.8, 0.75)])

# ------------------------------------------------------------- horizon glow
glow_line(0, HY, W, HY, CYAN, [(26, 0.05), (12, 0.09), (5, 0.16), (1.6, 0.60)])
glow_line(0, HY, W, HY, MAGENTA, [(46, 0.05)])

# ------------------------------------------------------------------- ground
A(f'<rect x="0" y="{HY}" width="{W}" height="{H-HY}" fill="url(#ground)"/>')
A(f'<ellipse cx="{CX}" cy="{HY}" rx="900" ry="820" fill="url(#reflect)" '
  f'clip-path="url(#belowhorizon)"/>')

# perspective grid — lines converging on the vanishing point
A('<g>')
step = 190
i = -22
while i <= 22:
    xb = CX + i * step
    fade = max(0.10, 1 - abs(i) / 26)
    glow_line(CX, HY, xb, H, BLUE, [(7, 0.04 * fade), (3, 0.09 * fade), (1.3, 0.34 * fade)])
    i += 1

n = 26
for k in range(1, n + 1):
    gy = HY + (H - HY) * (k / n) ** 2.35
    if gy > H:
        break
    fade = min(1.0, 0.20 + (k / n) * 1.15)
    glow_line(0, gy, W, gy, CYAN, [(7, 0.04 * fade), (3, 0.09 * fade), (1.3, 0.32 * fade)])
A('</g>')

# --------------------------------------------------------- atmosphere passes
A(f'<rect x="0" y="0" width="{W}" height="{H}" fill="url(#scan)"/>')
A(f'<rect x="0" y="0" width="{W}" height="{H}" fill="url(#vignette)"/>')
A('</svg>')

sys.stdout.write("\n".join(out))
