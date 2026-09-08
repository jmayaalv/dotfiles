#!/usr/bin/env python3
"""Claude Code quota and usage for the sketchybar widget.

Two sources, both local and credential-free:

  ~/.claude/statusline-cache.json  rate limit windows, reset times, context use.
      Claude Code passes this payload to the statusline command on stdin and
      writes it nowhere else, so statusline-command.sh tees it to that file.
  ~/.claude/projects/**/*.jsonl    per-model token counts for today.

  --bar      compact label for the bar
  --rows     icon/label/colour triples for the popup, \x1f separated
  --detail   full table for a terminal
  --json     raw figures
"""

import glob
import json
import os
import sys
import time
from datetime import datetime

STATUS_CACHE = os.path.expanduser("~/.claude/statusline-cache.json")
PROJECT_GLOBS = [
    os.path.expanduser("~/.claude/projects/**/*.jsonl"),
    os.path.expanduser("~/.config/claude/projects/**/*.jsonl"),
]

# USD per 1M tokens. Source: the claude-api skill model table (cached
# 2026-06-24). Sonnet 5's $2/$10 introductory rate ended 2026-08-31.
PRICING = {
    "claude-opus-5":     (5.00, 25.00),
    "claude-opus-4-8":   (5.00, 25.00),
    "claude-opus-4-7":   (5.00, 25.00),
    "claude-opus-4-6":   (5.00, 25.00),
    "claude-fable-5":    (10.00, 50.00),
    "claude-mythos-5":   (10.00, 50.00),
    "claude-sonnet-5":   (3.00, 15.00),
    "claude-sonnet-4-6": (3.00, 15.00),
    "claude-haiku-4-5":  (1.00, 5.00),
}
CACHE_READ_MULT = 0.10   # cache reads cost ~0.1x base input
CACHE_5M_MULT = 1.25     # 5-minute TTL write premium
CACHE_1H_MULT = 2.00     # 1-hour TTL write premium

# Smooth gauge: full blocks plus a fractional eighth-block, padded with light
# shade. Verified present in FiraCode Nerd Font's cmap.
EIGHTHS = "▏▎▍▌▋▊▉"
FULL, SHADE = "█", "░"
GAUGE_CELLS = 16
BAR_GAUGE_CELLS = 6
ROW_W = 49              # label width; section rules span exactly this

ICON_5H = "\uf017"      # fa-clock
ICON_7D = "\uf073"      # fa-calendar
ICON_MODEL = "\uf2db"   # fa-microchip
ICON_TOTAL = "\u03a3"   # sigma
STALE_AFTER = 900        # seconds before the quota figures are called stale


# ---------------------------------------------------------------- presentation

def gauge(pct, cells=GAUGE_CELLS):
    """Fill represents what is LEFT, so a full bar reads as plenty remaining."""
    f = max(0.0, min(100.0, float(pct))) / 100.0 * cells
    full = int(f)
    out = FULL * full
    idx = int((f - full) * 8)
    if full < cells and idx > 0:
        out += EIGHTHS[idx - 1]
    return out + SHADE * (cells - len(out))


def severity(used):
    """Colour key from how much of a window is consumed."""
    if used >= 90:
        return "crit"
    if used >= 70:
        return "hot"
    if used >= 50:
        return "warn"
    return "ok"


def rule(title=None):
    """A dim divider, optionally opening with a section title."""
    if not title:
        return SHADE and "─" * ROW_W
    return f"{title} " + "─" * max(0, ROW_W - len(title) - 1)


def human_tokens(n):
    # The 0.9995 factor promotes to the next unit before rounding can produce a
    # nonsense figure like "1000k" for 999,999.
    for div, suf in ((1_000_000_000, "B"), (1_000_000, "M"), (1_000, "k")):
        if n >= div * 0.9995:
            v = n / div
            return f"{v:.1f}{suf}" if v < 9.9995 else f"{v:.0f}{suf}"
    return str(n)


def human_delta(seconds):
    """Compact countdown: 3d4h, 4h12m, 38m, 45s, now."""
    s = int(seconds)
    if s <= 0:
        return "now"
    if s < 60:
        return f"{s}s"
    d, rem = divmod(s, 86400)
    h, rem = divmod(rem, 3600)
    m = rem // 60
    if d:
        return f"{d}d{h}h"
    if h:
        return f"{h}h{m:02d}m"
    return f"{m}m"


def reset_clock(ts):
    """Local wall-clock of the reset, day-qualified when it is not today."""
    when = datetime.fromtimestamp(ts)
    now = datetime.now()
    if when.date() == now.date():
        return when.strftime("%H:%M")
    if (when.date() - now.date()).days == 1:
        return when.strftime("tomorrow %H:%M")
    return when.strftime("%a %H:%M")


# ------------------------------------------------------------------- data load

def load_quota():
    """Rate-limit windows and context usage, or None if unavailable."""
    try:
        with open(STATUS_CACHE) as fh:
            d = json.load(fh)
    except (OSError, ValueError):
        return None

    # Only the rate-limit windows are read. Everything else in the payload -
    # context window, cost.total_cost_usd, model display name - describes the
    # single conversation that happened to render last, which has no meaning in
    # a bar shared by every session.
    rl = d.get("rate_limits") or {}
    out = {
        "age": time.time() - os.path.getmtime(STATUS_CACHE),
        "windows": [],
    }
    for key, label in (("five_hour", "5h"), ("seven_day", "7d")):
        w = rl.get(key)
        if not isinstance(w, dict):
            continue
        used = w.get("used_percentage")
        if used is None:
            continue
        out["windows"].append({
            "label": label,
            "used": float(used),
            "resets_at": w.get("resets_at"),
        })
    return out


def cost_of(model, a):
    rates = PRICING.get(model)
    if not rates:
        return None
    inp, out = rates
    return (a["inp"] * inp + a["out"] * out
            + a["read"] * inp * CACHE_READ_MULT
            + a["w5"] * inp * CACHE_5M_MULT
            + a["w1h"] * inp * CACHE_1H_MULT) / 1_000_000


def total_tokens(a):
    return a["inp"] + a["out"] + a["read"] + a["w5"] + a["w1h"]


def load_today():
    """Per-model token counts for today from the session logs."""
    start = datetime.now().replace(hour=0, minute=0, second=0, microsecond=0)
    start_ts = start.timestamp()
    seen, per_model, sessions = set(), {}, set()
    messages = 0

    files = []
    for pattern in PROJECT_GLOBS:
        files.extend(glob.glob(pattern, recursive=True))

    for path in files:
        try:
            if os.path.getmtime(path) < start_ts:
                continue
            with open(path, errors="ignore") as fh:
                for line in fh:
                    try:
                        d = json.loads(line)
                    except ValueError:
                        continue
                    msg = d.get("message")
                    if not isinstance(msg, dict):
                        continue
                    usage = msg.get("usage")
                    if not isinstance(usage, dict):
                        continue
                    raw = d.get("timestamp")
                    if not raw:
                        continue
                    try:
                        ts = datetime.fromisoformat(raw.replace("Z", "+00:00"))
                    except ValueError:
                        continue
                    if ts.tzinfo is not None:
                        ts = ts.astimezone().replace(tzinfo=None)
                    if ts < start:
                        continue

                    # Resumed sessions re-log entries; dedupe as ccusage does.
                    key = (msg.get("id"), d.get("requestId"))
                    if key != (None, None):
                        if key in seen:
                            continue
                        seen.add(key)

                    model = msg.get("model") or "unknown"
                    if model == "<synthetic>":
                        continue
                    if d.get("sessionId"):
                        sessions.add(d["sessionId"])
                    messages += 1

                    cc = usage.get("cache_creation") or {}
                    acc = per_model.setdefault(
                        model, dict(inp=0, out=0, read=0, w5=0, w1h=0, n=0))
                    acc["inp"] += usage.get("input_tokens", 0) or 0
                    acc["out"] += usage.get("output_tokens", 0) or 0
                    acc["read"] += usage.get("cache_read_input_tokens", 0) or 0
                    if cc:
                        acc["w5"] += cc.get("ephemeral_5m_input_tokens", 0) or 0
                        acc["w1h"] += cc.get("ephemeral_1h_input_tokens", 0) or 0
                    else:
                        acc["w5"] += usage.get("cache_creation_input_tokens", 0) or 0
                    acc["n"] += 1
        except OSError:
            continue
    return per_model, sessions, messages


# ---------------------------------------------------------------------- output

def binding_window(q):
    """The window closest to exhaustion - the one the bar reflects."""
    if not q or not q["windows"]:
        return None
    return max(q["windows"], key=lambda w: w["used"])


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "--bar"
    q = load_quota()

    if mode == "--bar":
        w = binding_window(q)
        if not w:
            print("--")
            return
        left = 100 - w["used"]
        cd = human_delta(w["resets_at"] - time.time()) if w["resets_at"] else ""
        print(f"{w['label']} {gauge(left, BAR_GAUGE_CELLS)} {left:>2.0f}%"
              + (f"  {cd}" if cd else ""))
        return

    if mode == "--severity":
        w = binding_window(q)
        print(f"{w['used']:.0f}" if w else "0")
        return

    if mode == "--json":
        per_model, sessions, messages = load_today()
        print(json.dumps({
            "quota": q,
            "today": {"sessions": len(sessions), "messages": messages,
                      "models": {m: {**a, "cost": cost_of(m, a)}
                                 for m, a in per_model.items()}},
        }, indent=2, default=str))
        return

    per_model, sessions, messages = load_today()
    tokens = sum(total_tokens(a) for a in per_model.values())
    costs = [cost_of(m, a) for m, a in per_model.items()]
    cost = sum(c for c in costs if c is not None)
    ranked = sorted(per_model.items(), key=lambda kv: -total_tokens(kv[1]))

    if mode == "--rows":
        # icon <TAB> label <TAB> colour-key
        rows = []
        if q and q["windows"]:
            rows.append(("", rule("LIMITS"), "dim"))
            for w in q["windows"]:
                left = 100 - w["used"]
                clock = reset_clock(w["resets_at"]) if w["resets_at"] else ""
                cd = human_delta(w["resets_at"] - time.time()) if w["resets_at"] else ""
                rows.append((
                    ICON_5H if w["label"] == "5h" else ICON_7D,
                    f"{w['label']:<4}{gauge(left)}  {left:>3.0f}% left"
                    f"   {clock:<10}{cd:>6}",
                    severity(w["used"]),
                ))
            if q["age"] > STALE_AFTER:
                rows.append(("", f"{'':<4}figures {human_delta(q['age'])} old", "dim"))
        if ranked:
            rows.append(("", rule("TODAY"), "dim"))
            for m, a in ranked:
                c = cost_of(m, a)
                rows.append((
                    ICON_MODEL,
                    f"{m.replace('claude-', ''):<20}"
                    f"{human_tokens(total_tokens(a)):>14}"
                    f"{('$%.2f' % c) if c is not None else 'n/a':>15}",
                    "text",
                ))
            if len(ranked) > 1:
                rows.append((ICON_TOTAL,
                             f"{'total':<20}{human_tokens(tokens):>14}"
                             f"{'$%.2f' % cost:>15}", "accent"))
        # \x1f (unit separator) rather than tab: a tab is IFS whitespace, so an
        # empty icon field would be swallowed by the reader and shift the columns.
        for icon, label, key in rows:
            print(f"{icon}\x1f{label}\x1f{key}")
        return

    # --detail, for the terminal
    C = {"ok": "\033[32m", "warn": "\033[33m", "hot": "\033[38;5;209m",
         "crit": "\033[31m", "dim": "\033[2m", "accent": "\033[38;5;183m",
         "off": "\033[0m", "bold": "\033[1m"}
    print()
    if q and q["windows"]:
        print(f"  {C['dim']}{rule('LIMITS')}{C['off']}")
        for w in q["windows"]:
            left = 100 - w["used"]
            col = C[severity(w["used"])]
            clock = reset_clock(w["resets_at"]) if w["resets_at"] else ""
            cd = human_delta(w["resets_at"] - time.time()) if w["resets_at"] else ""
            print(f"  {col}{w['label']:<4}{gauge(left)}{C['off']}"
                  f"  {col}{left:>3.0f}% left{C['off']}"
                  f"   {C['dim']}{clock:<10}{cd:>6}{C['off']}")
        if q["age"] > STALE_AFTER:
            print(f"  {C['dim']}    figures {human_delta(q['age'])} old"
                  f" - Claude Code may not be running{C['off']}")
    else:
        print(f"  {C['dim']}no quota data - is the statusline configured?{C['off']}")
    print()
    if ranked:
        print(f"  {C['dim']}{rule('TODAY')}{C['off']}")
        for m, a in ranked:
            c = cost_of(m, a)
            print(f"  {m.replace('claude-', ''):<20}"
                  f"{human_tokens(total_tokens(a)):>14}"
                  f"{('$%.2f' % c) if c is not None else 'n/a':>15}")
        if len(ranked) > 1:
            print(f"  {C['accent']}{'total':<20}{human_tokens(tokens):>14}"
                  f"{'$%.2f' % cost:>15}{C['off']}")
        print(f"\n  {C['dim']}{len(sessions)} sessions"
              f"   {messages} messages{C['off']}")
    print()
    print(f"  {C['dim']}Cost is an estimate at published API rates,"
          f" not a bill.{C['off']}")
    print()


if __name__ == "__main__":
    main()
