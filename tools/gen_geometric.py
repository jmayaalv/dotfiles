#!/usr/bin/env python3
"""Generate a geometric / Bauhaus-flavoured wallpaper in the Catppuccin Mocha palette.

Emits SVG to stdout; render with rsvg-convert. Deterministic via a fixed seed.
"""
import math
import random
import sys

W, H = 3456, 2170

# Catppuccin Mocha
BG_TOP    = "#14141f"
BG_MID    = "#1e1e2e"
BG_BOT    = "#17172440"
FG        = "#cdd6f4"
MUTED     = "#585b70"
SELECTION = "#45475a"
BLUE      = "#89b4fa"
CYAN      = "#94e2d5"
MAGENTA   = "#f5c2e7"
PINK      = "#f38ba8"
YELLOW    = "#f9e2af"
GREEN     = "#a6e3a1"
ORANGE    = "#f6b6ab"

seed = int(sys.argv[1]) if len(sys.argv) > 1 else 3
rnd = random.Random(seed)
out = []
A = out.append

# Focal centre, placed off-centre rather than dead middle.
FX, FY = W * 0.615, H * 0.455


def arc_path(cx, cy, r, a0, a1):
    """SVG path for a circular arc, angles in degrees, 0 = east, clockwise."""
    x0 = cx + r * math.cos(math.radians(a0))
    y0 = cy + r * math.sin(math.radians(a0))
    x1 = cx + r * math.cos(math.radians(a1))
    y1 = cy + r * math.sin(math.radians(a1))
    large = 1 if abs(a1 - a0) > 180 else 0
    sweep = 1 if a1 > a0 else 0
    return (f'M {x0:.1f} {y0:.1f} A {r:.1f} {r:.1f} 0 {large} {sweep} {x1:.1f} {y1:.1f}')


def poly(points, **kw):
    pts = " ".join(f"{x:.1f},{y:.1f}" for x, y in points)
    attrs = " ".join(f'{k.replace("_","-")}="{v}"' for k, v in kw.items())
    A(f'<polygon points="{pts}" {attrs}/>')


A(f'<svg xmlns="http://www.w3.org/2000/svg" width="{W}" height="{H}" viewBox="0 0 {W} {H}">')

# ---------------------------------------------------------------- definitions
A('<defs>')
A(f'''<linearGradient id="bg" x1="0.1" y1="0" x2="0.9" y2="1">
  <stop offset="0%"   stop-color="{BG_TOP}"/>
  <stop offset="55%"  stop-color="{BG_MID}"/>
  <stop offset="100%" stop-color="#191926"/>
</linearGradient>''')

A(f'''<radialGradient id="halo" cx="50%" cy="50%" r="50%">
  <stop offset="0%"   stop-color="{BLUE}" stop-opacity="0.16"/>
  <stop offset="55%"  stop-color="{MAGENTA}" stop-opacity="0.05"/>
  <stop offset="100%" stop-color="{MAGENTA}" stop-opacity="0"/>
</radialGradient>''')

A(f'''<linearGradient id="discfill" x1="0" y1="0" x2="1" y2="1">
  <stop offset="0%"   stop-color="{MAGENTA}" stop-opacity="0.95"/>
  <stop offset="100%" stop-color="{PINK}" stop-opacity="0.85"/>
</linearGradient>''')

A(f'''<linearGradient id="halffill" x1="0" y1="0" x2="1" y2="1">
  <stop offset="0%"   stop-color="{CYAN}" stop-opacity="0.90"/>
  <stop offset="100%" stop-color="{BLUE}" stop-opacity="0.75"/>
</linearGradient>''')

A(f'''<radialGradient id="vignette" cx="50%" cy="46%" r="76%">
  <stop offset="0%"   stop-color="#000000" stop-opacity="0"/>
  <stop offset="60%"  stop-color="#000000" stop-opacity="0"/>
  <stop offset="100%" stop-color="#000000" stop-opacity="0.50"/>
</radialGradient>''')
A('</defs>')

# ------------------------------------------------------------------ ground
A(f'<rect x="0" y="0" width="{W}" height="{H}" fill="url(#bg)"/>')
A(f'<ellipse cx="{FX:.0f}" cy="{FY:.0f}" rx="1500" ry="1300" fill="url(#halo)"/>')

# technical grid — fine cells with a heavier module every 5th line
A('<g>')
CELL = 96
x = 0
while x <= W:
    heavy = (x % (CELL * 5) == 0)
    A(f'<line x1="{x}" y1="0" x2="{x}" y2="{H}" stroke="{FG}" '
      f'stroke-width="{1.6 if heavy else 1.1}" opacity="{0.085 if heavy else 0.042}"/>')
    x += CELL
y = 0
while y <= H:
    heavy = (y % (CELL * 5) == 0)
    A(f'<line x1="0" y1="{y}" x2="{W}" y2="{y}" stroke="{FG}" '
      f'stroke-width="{1.6 if heavy else 1.1}" opacity="{0.085 if heavy else 0.042}"/>')
    y += CELL
A('</g>')

# counterweight: a large ring bleeding off the left edge, balancing the
# focal cluster on the right without crowding the usable desktop area
A(f'<circle cx="{-W*0.09:.0f}" cy="{H*0.74:.0f}" r="900" fill="none" '
  f'stroke="{SELECTION}" stroke-width="2.4" opacity="0.85"/>')
A(f'<circle cx="{-W*0.09:.0f}" cy="{H*0.74:.0f}" r="1080" fill="none" '
  f'stroke="{MUTED}" stroke-width="1.6" opacity="0.40" stroke-dasharray="3 22"/>')

# full-bleed rules that tie the composition to the canvas edges
for ry, col, op, wdt in [
    (H * 0.235, MUTED, 0.62, 1.8),
    (H * 0.455, BLUE,  0.42, 1.8),
    (H * 0.788, MUTED, 0.52, 1.8),
]:
    A(f'<line x1="0" y1="{ry:.0f}" x2="{W}" y2="{ry:.0f}" stroke="{col}" '
      f'stroke-width="{wdt}" opacity="{op}"/>')
A(f'<line x1="{FX:.0f}" y1="0" x2="{FX:.0f}" y2="{H}" stroke="{MUTED}" '
  f'stroke-width="1.8" opacity="0.48"/>')

# ------------------------------------------------------- concentric ring system
rings = [
    (640, BLUE,    0.55, 2.2),
    (548, SELECTION, 0.90, 1.6),
    (452, MAGENTA, 0.40, 2.0),
    (330, CYAN,    0.34, 1.6),
    (232, MUTED,   0.70, 1.4),
]
for r, col, op, wdt in rings:
    A(f'<circle cx="{FX:.0f}" cy="{FY:.0f}" r="{r}" fill="none" stroke="{col}" '
      f'stroke-width="{wdt}" opacity="{op}"/>')

# heavy accent arcs riding a couple of those radii
A(f'<path d="{arc_path(FX, FY, 640, -142, -18)}" fill="none" stroke="{YELLOW}" '
  f'stroke-width="9" opacity="0.90" stroke-linecap="round"/>')
A(f'<path d="{arc_path(FX, FY, 452, 34, 156)}" fill="none" stroke="{GREEN}" '
  f'stroke-width="7" opacity="0.80" stroke-linecap="round"/>')
A(f'<path d="{arc_path(FX, FY, 548, 168, 250)}" fill="none" stroke="{ORANGE}" '
  f'stroke-width="5" opacity="0.75" stroke-linecap="round"/>')

# dashed orbit for texture
A(f'<circle cx="{FX:.0f}" cy="{FY:.0f}" r="760" fill="none" stroke="{MUTED}" '
  f'stroke-width="1.6" opacity="0.55" stroke-dasharray="3 22"/>')

# ticks around the outer orbit
A('<g>')
for i in range(72):
    ang = math.radians(i * 5)
    long_tick = (i % 6 == 0)
    r0, r1 = 700, 700 + (26 if long_tick else 12)
    A(f'<line x1="{FX + r0*math.cos(ang):.1f}" y1="{FY + r0*math.sin(ang):.1f}" '
      f'x2="{FX + r1*math.cos(ang):.1f}" y2="{FY + r1*math.sin(ang):.1f}" '
      f'stroke="{MUTED}" stroke-width="{2.4 if long_tick else 1.6}" '
      f'opacity="{0.85 if long_tick else 0.50}"/>')
A('</g>')

# ------------------------------------------------------------- solid forms
# primary disc, slightly off the focal centre
A(f'<circle cx="{FX-96:.0f}" cy="{FY+52:.0f}" r="188" fill="url(#discfill)"/>')

# half-disc, cut on the vertical
A(f'<path d="M {FX+232:.0f} {FY-268:.0f} A 176 176 0 0 1 {FX+232:.0f} {FY+84:.0f} Z" '
  f'fill="url(#halffill)"/>')

# rotated square outline
sq = 214
A(f'<g transform="rotate(45 {FX+430:.0f} {FY+330:.0f})">'
  f'<rect x="{FX+430-sq/2:.0f}" y="{FY+330-sq/2:.0f}" width="{sq}" height="{sq}" '
  f'fill="none" stroke="{YELLOW}" stroke-width="3" opacity="0.85"/></g>')

# triangle outline, counterweight to the lower left
poly([(FX-690, FY+430), (FX-430, FY+430), (FX-560, FY+206)],
     fill="none", stroke=CYAN, stroke_width="3", opacity="0.75")

# small filled triangle
poly([(FX-118, FY-392), (FX+10, FY-392), (FX-54, FY-502)],
     fill=PINK, opacity="0.85")

# bar stack, lower left — flat colour blocks for weight
bx, by = W * 0.108, H * 0.655
for i, (col, bw) in enumerate([(BLUE, 300), (MAGENTA, 214), (YELLOW, 140), (MUTED, 86)]):
    A(f'<rect x="{bx:.0f}" y="{by + i*46:.0f}" width="{bw}" height="20" '
      f'fill="{col}" opacity="{0.85 - i*0.10:.2f}" rx="10"/>')

# thin outline circles scattered on grid intersections
A('<g>')
for _ in range(14):
    gx = rnd.randrange(2, W // CELL - 1) * CELL
    gy = rnd.randrange(2, H // CELL - 1) * CELL
    if math.hypot(gx - FX, gy - FY) < 820:
        continue
    r = rnd.choice([9, 13, 18, 26])
    col = rnd.choice([BLUE, CYAN, MAGENTA, MUTED, YELLOW])
    A(f'<circle cx="{gx}" cy="{gy}" r="{r}" fill="none" stroke="{col}" '
      f'stroke-width="1.8" opacity="{rnd.uniform(0.30, 0.70):.2f}"/>')
A('</g>')

# solid dots on intersections
A('<g>')
for _ in range(20):
    gx = rnd.randrange(1, W // CELL) * CELL
    gy = rnd.randrange(1, H // CELL) * CELL
    if math.hypot(gx - FX, gy - FY) < 780:
        continue
    col = rnd.choice([FG, BLUE, MAGENTA, CYAN, YELLOW])
    A(f'<circle cx="{gx}" cy="{gy}" r="{rnd.choice([3,4,5])}" fill="{col}" '
      f'opacity="{rnd.uniform(0.25, 0.65):.2f}"/>')
A('</g>')

# corner bracket marks, like registration crops
for cx_, cy_, sx, sy in [(150, 150, 1, 1), (W-150, 150, -1, 1),
                         (150, H-150, 1, -1), (W-150, H-150, -1, -1)]:
    A(f'<path d="M {cx_} {cy_ + sy*74} L {cx_} {cy_} L {cx_ + sx*74} {cy_}" '
      f'fill="none" stroke="{MUTED}" stroke-width="2" opacity="0.45"/>')

A(f'<rect x="0" y="0" width="{W}" height="{H}" fill="url(#vignette)"/>')
A('</svg>')

sys.stdout.write("\n".join(out))
