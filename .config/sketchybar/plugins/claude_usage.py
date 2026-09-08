#!/usr/bin/env python3
"""Summarise today's Claude Code usage from the local session logs.

Reads ~/.claude/projects/**/*.jsonl, which Claude Code writes as it works, so
this needs no network, no credentials and no external packages.

  --bar      one compact line for the sketchybar label
  --rows     tab-separated pairs for the sketchybar popup
  --detail   per-model table, for reading in a terminal
  --json     raw figures
"""

import glob
import json
import os
import sys
from datetime import datetime, timezone

PROJECT_GLOBS = [
    os.path.expanduser("~/.claude/projects/**/*.jsonl"),
    os.path.expanduser("~/.config/claude/projects/**/*.jsonl"),
]

# USD per 1M tokens. Source: the claude-api skill's model table (cached
# 2026-06-24). Sonnet 5's $2/$10 introductory rate ended 2026-08-31.
# Unknown models contribute tokens but no cost, and are flagged in --detail.
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

# Cache multipliers applied to a model's input rate.
CACHE_READ_MULT = 0.10   # cache reads cost ~0.1x base input
CACHE_5M_MULT = 1.25     # 5-minute TTL write premium
CACHE_1H_MULT = 2.00     # 1-hour TTL write premium


def today_bounds():
    now = datetime.now()
    start = now.replace(hour=0, minute=0, second=0, microsecond=0)
    return start, start.timestamp()


def entry_is_today(ts_raw, start):
    """Claude Code writes ISO timestamps in UTC; compare in local time."""
    if not ts_raw:
        return False
    try:
        ts = datetime.fromisoformat(ts_raw.replace("Z", "+00:00"))
    except ValueError:
        return False
    if ts.tzinfo is not None:
        ts = ts.astimezone().replace(tzinfo=None)
    return ts >= start


def collect():
    start, start_ts = today_bounds()
    seen = set()
    per_model = {}
    sessions = set()
    messages = 0

    files = []
    for pattern in PROJECT_GLOBS:
        files.extend(glob.glob(pattern, recursive=True))

    for path in files:
        try:
            # Only files touched today can hold today's entries.
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
                    if not entry_is_today(d.get("timestamp"), start):
                        continue

                    # Resumed sessions re-log entries; dedupe on the message and
                    # request ids the way ccusage does.
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
                    acc = per_model.setdefault(model, dict(
                        inp=0, out=0, read=0, w5=0, w1h=0, n=0))
                    acc["inp"] += usage.get("input_tokens", 0) or 0
                    acc["out"] += usage.get("output_tokens", 0) or 0
                    acc["read"] += usage.get("cache_read_input_tokens", 0) or 0
                    if cc:
                        acc["w5"] += cc.get("ephemeral_5m_input_tokens", 0) or 0
                        acc["w1h"] += cc.get("ephemeral_1h_input_tokens", 0) or 0
                    else:
                        # Older logs only carry the flat total; assume 5m TTL.
                        acc["w5"] += usage.get("cache_creation_input_tokens", 0) or 0
                    acc["n"] += 1
        except OSError:
            continue

    return per_model, sessions, messages


def cost_of(model, a):
    rates = PRICING.get(model)
    if not rates:
        return None
    inp, out = rates
    return (
        a["inp"] * inp
        + a["out"] * out
        + a["read"] * inp * CACHE_READ_MULT
        + a["w5"] * inp * CACHE_5M_MULT
        + a["w1h"] * inp * CACHE_1H_MULT
    ) / 1_000_000


def total_tokens(a):
    return a["inp"] + a["out"] + a["read"] + a["w5"] + a["w1h"]


def human(n):
    for div, suf in ((1_000_000_000, "B"), (1_000_000, "M"), (1_000, "k")):
        if n >= div:
            v = n / div
            return f"{v:.1f}{suf}" if v < 10 else f"{v:.0f}{suf}"
    return str(n)


def main():
    mode = sys.argv[1] if len(sys.argv) > 1 else "--bar"
    per_model, sessions, messages = collect()

    tokens = sum(total_tokens(a) for a in per_model.values())
    costs = [cost_of(m, a) for m, a in per_model.items()]
    cost = sum(c for c in costs if c is not None)
    unpriced = any(c is None for c in costs)

    if mode == "--bar":
        if not per_model:
            print("--")
        else:
            print(f"{human(tokens)}  ${cost:.2f}" + ("*" if unpriced else ""))
        return

    if mode == "--json":
        print(json.dumps({
            "tokens": tokens, "cost": cost, "sessions": len(sessions),
            "messages": messages,
            "models": {m: {**a, "cost": cost_of(m, a)} for m, a in per_model.items()},
        }, indent=2))
        return

    if mode == "--rows":
        # Tab-separated left/right pairs for the sketchybar popup.
        if not per_model:
            print("today\tno activity")
            return
        for m, a in sorted(per_model.items(), key=lambda kv: -total_tokens(kv[1])):
            c = cost_of(m, a)
            print(f"{m.replace('claude-','')}\t{human(total_tokens(a))}   "
                  f"{('$%.2f' % c) if c is not None else 'n/a'}")
        print(f"total\t{human(tokens)}   ${cost:.2f}")
        print(f"sessions\t{len(sessions)}")
        print(f"messages\t{messages}")
        return

    # --detail
    if not per_model:
        print("no Claude Code activity today")
        return
    rows = sorted(per_model.items(), key=lambda kv: -total_tokens(kv[1]))
    print(f"{'MODEL':<18}{'TOKENS':>9}{'COST':>9}")
    for m, a in rows:
        c = cost_of(m, a)
        label = m.replace("claude-", "")
        print(f"{label:<18}{human(total_tokens(a)):>9}"
              f"{('$%.2f' % c) if c is not None else 'n/a':>9}")
    print(f"{'-' * 36}")
    print(f"{'total':<18}{human(tokens):>9}{'$%.2f' % cost:>9}")
    print(f"\nsessions {len(sessions)}   messages {messages}")
    if unpriced:
        print("* some models have no price entry")


if __name__ == "__main__":
    main()
