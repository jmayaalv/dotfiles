#!/usr/bin/env python3
"""Claude Code quota and usage for the sketchybar widget.

Two sources, both local and credential-free:

  ~/.claude/statusline-cache.json  rate limit windows, reset times, context use.
      Claude Code passes this payload to the statusline command on stdin and
      writes it nowhere else, so statusline-command.sh tees it to that file.
  ~/.claude/projects/**/*.jsonl    per-model token counts for today.

  --bar      compact label for the bar
  --rows     tab-separated pairs for the popup
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

FILLED, EMPTY = "▰", "▱"
BAR_SEGMENTS = 10
STALE_AFTER = 900        # seconds before the quota figures are called stale


# ---------------------------------------------------------------- presentation

def gauge(pct, segments=BAR_SEGMENTS):
    pct = max(0.0, min(100.0, float(pct)))
    on = int(round(pct / 100.0 * segments))
    return FILLED * on + EMPTY * (segments - on)


def human_tokens(n):
    for div, suf in ((1_000_000_000, "B"), (1_000_000, "M"), (1_000, "k")):
        if n >= div:
            v = n / div
            return f"{v:.1f}{suf}" if v < 10 else f"{v:.0f}{suf}"
    return str(n)


def human_delta(seconds):
    """Compact countdown: 3d4h, 4h12m, 38m, now."""
    s = int(seconds)
    if s <= 0:
        return "now"
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

    rl = d.get("rate_limits") or {}
    cw = d.get("context_window") or {}
    out = {
        "age": time.time() - os.path.getmtime(STATUS_CACHE),
        "model": (d.get("model") or {}).get("display_name"),
        "session_cost": (d.get("cost") or {}).get("total_cost_usd"),
        "ctx_used": cw.get("used_percentage"),
        "ctx_size": cw.get("context_window_size"),
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
    """The window closest to exhaustion - the one worth showing on the bar."""
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
        bits = [f"{left:.0f}%"]
        if w["resets_at"]:
            bits.append(human_delta(w["resets_at"] - time.time()))
        print(f"{w['label']} {'  '.join(bits)}")
        return

    if mode == "--severity":
        # Highest used_percentage across windows, for the icon colour.
        w = binding_window(q)
        print(f"{w['used']:.0f}" if w else "0")
        return

    if mode == "--json":
        per_model, sessions, messages = load_today()
        print(json.dumps({
            "quota": q,
            "today": {
                "sessions": len(sessions), "messages": messages,
                "models": {m: {**a, "cost": cost_of(m, a)}
                           for m, a in per_model.items()},
            },
        }, indent=2, default=str))
        return

    per_model, sessions, messages = load_today()
    tokens = sum(total_tokens(a) for a in per_model.values())
    costs = [cost_of(m, a) for m, a in per_model.items()]
    cost = sum(c for c in costs if c is not None)

    if mode == "--rows":
        rows = []
        if q:
            for w in q["windows"]:
                left = 100 - w["used"]
                right = f"{gauge(w['used'])}  {left:>3.0f}% left"
                if w["resets_at"]:
                    right += (f"  ·  {reset_clock(w['resets_at'])}"
                              f"  ({human_delta(w['resets_at'] - time.time())})")
                rows.append((w["label"], right))
            if q["ctx_used"] is not None:
                size = q["ctx_size"] or 0
                left_tok = int(size * (100 - q["ctx_used"]) / 100) if size else 0
                rows.append(("ctx", f"{gauge(q['ctx_used'])}  "
                                    f"{100 - q['ctx_used']:>3.0f}% left"
                                    f"  ·  {human_tokens(left_tok)} free"))
            if q["age"] > STALE_AFTER:
                rows.append(("", f"quota {human_delta(q['age'])} old"))
        if per_model:
            rows.append(("", ""))          # spacer
            for m, a in sorted(per_model.items(), key=lambda kv: -total_tokens(kv[1])):
                c = cost_of(m, a)
                rows.append((m.replace("claude-", ""),
                             f"{human_tokens(total_tokens(a)):>5}"
                             f"  {('$%.2f' % c) if c is not None else 'n/a':>7}"))
            rows.append(("today", f"{human_tokens(tokens):>5}  {'$%.2f' % cost:>7}"))
        if q and q.get("session_cost") is not None:
            rows.append(("session", f"{'$%.2f' % q['session_cost']:>14}"))
        for left, right in rows:
            print(f"{left}\t{right}")
        return

    # --detail
    print()
    if q:
        print("  \033[1mQUOTA\033[0m")
        for w in q["windows"]:
            left = 100 - w["used"]
            line = f"    {w['label']:<4} {gauge(w['used'])} {left:>3.0f}% left"
            if w["resets_at"]:
                line += (f"   resets {reset_clock(w['resets_at'])}"
                         f" ({human_delta(w['resets_at'] - time.time())})")
            print(line)
        if q["ctx_used"] is not None:
            print(f"    {'ctx':<4} {gauge(q['ctx_used'])} "
                  f"{100 - q['ctx_used']:>3.0f}% left"
                  f"   {q['model'] or ''}")
        if q["age"] > STALE_AFTER:
            print(f"    (figures {human_delta(q['age'])} old - "
                  f"Claude Code may not be running)")
    else:
        print("  QUOTA unavailable - no statusline cache yet")
    print()
    if per_model:
        print("  \033[1mTODAY\033[0m")
        print(f"    {'model':<14}{'tokens':>8}{'cost':>9}")
        for m, a in sorted(per_model.items(), key=lambda kv: -total_tokens(kv[1])):
            c = cost_of(m, a)
            print(f"    {m.replace('claude-',''):<14}"
                  f"{human_tokens(total_tokens(a)):>8}"
                  f"{('$%.2f' % c) if c is not None else 'n/a':>9}")
        print(f"    {'-' * 31}")
        print(f"    {'total':<14}{human_tokens(tokens):>8}{'$%.2f' % cost:>9}")
        print(f"\n    sessions {len(sessions)}   messages {messages}")
    print()
    print("  Cost is an estimate at published API rates, not a bill.")
    print()


if __name__ == "__main__":
    main()
