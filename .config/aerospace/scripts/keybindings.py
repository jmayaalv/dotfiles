#!/usr/bin/env python3
"""Render AeroSpace's keybindings as a grouped cheatsheet.

Parses aerospace.toml at runtime so the output can never drift from the real
bindings. The cmd-ctrl-alt prefix that Karabiner produces from right Command is
displayed as SUPER, which is how it is actually used.
"""

import os
import re
import shutil
import sys
import tomllib

CONFIG = os.path.expanduser("~/.config/aerospace/aerospace.toml")

SUPER = "cmd-ctrl-alt"
KEYSYM = {
    "left": "←", "right": "→", "up": "↑", "down": "↓",
    "enter": "↵", "tab": "⇥", "backspace": "⌫", "esc": "esc",
    "minus": "-", "equal": "=", "slash": "/", "comma": ",", "period": ".",
    "semicolon": ";", "backtick": "`", "space": "space",
}

# Ordered: (heading, predicate on the aerospace command)
GROUPS = [
    ("WINDOWS",    lambda c: c.split()[0] in ("close", "fullscreen", "layout")),
    ("FOCUS",      lambda c: c.startswith("focus")),
    ("MOVE",       lambda c: c.startswith("move ")),
    ("RESIZE",     lambda c: c.startswith("resize")),
    ("WORKSPACES", lambda c: "workspace" in c),
    ("APPS",       lambda c: c.startswith("exec-and-forget open -a")),
    ("MODES",      lambda c: c.startswith("mode") or c.startswith("exec-and-forget")),
]

ANSI = {"bold": "\033[1m", "dim": "\033[2m", "accent": "\033[38;5;183m",
        "head": "\033[38;5;117m", "off": "\033[0m"}


def pretty_key(binding: str) -> str:
    """cmd-ctrl-alt-shift-left -> SUPER+SHIFT+<-"""
    rest = binding
    if rest.startswith(SUPER):
        rest = rest[len(SUPER):].lstrip("-")
        parts = ["SUPER"]
    else:
        parts = []
    shift = False
    if rest.startswith("shift-"):
        rest, shift = rest[len("shift-"):], True
    elif rest == "shift":
        rest, shift = "", True
    if shift:
        parts.append("SHIFT")
    if rest:
        parts.append(KEYSYM.get(rest, rest.upper() if len(rest) == 1 else rest))
    return "+".join(parts)


def pretty_action(cmd: str) -> str:
    if cmd.startswith("exec-and-forget open -a"):
        path = cmd.split("open -a", 1)[1].strip().strip("'\"")
        return os.path.basename(path).replace(".app", "")
    if "show-keybindings" in cmd:
        return "this cheatsheet"
    if "claude_click" in cmd:
        return "claude usage popup"
    if cmd.startswith("exec-and-forget"):
        # any other script: show its basename rather than the whole command line
        m = re.search(r"([\w.-]+)\.(sh|py|bash)", cmd)
        return m.group(1).replace("-", " ") if m else "run script"
    cmd = re.sub(r"\s*--focus-follows-window", "", cmd)
    cmd = re.sub(r"\s*--wrap-around", "", cmd)
    return {
        "close": "close window",
        "fullscreen": "fullscreen",
        "layout floating tiling": "toggle float/tile",
        "layout tiles horizontal vertical": "toggle split",
        "layout accordion horizontal vertical": "toggle accordion",
        "workspace-back-and-forth": "back and forth",
        "mode service": "service mode",
        "resize width -100": "narrower",
        "resize width +100": "wider",
        "resize height -100": "shorter",
        "resize height +100": "taller",
        "workspace next": "next workspace",
        "move-node-to-workspace S": "stash window in scratchpad",
        "workspace prev": "previous workspace",
    }.get(cmd, cmd)


def collapse(rows):
    """1..5 runs of identical actions collapse to a single line."""
    out, i = [], 0
    while i < len(rows):
        key, act = rows[i]
        m = re.match(r"^(.*?)(\d)$", key)
        if m:
            prefix, start = m.group(1), int(m.group(2))
            base_act = re.sub(r"\d+", "N", act)
            j, last = i + 1, start
            while j < len(rows):
                m2 = re.match(r"^(.*?)(\d)$", rows[j][0])
                if (m2 and m2.group(1) == prefix
                        and int(m2.group(2)) == last + 1
                        and re.sub(r"\d+", "N", rows[j][1]) == base_act):
                    last = int(m2.group(2)); j += 1
                else:
                    break
            if last > start:
                act = re.sub(r"\s*\d+$", "", act).strip()
                act = {
                    "workspace": "switch to workspace",
                    "move-node-to-workspace": "move window to workspace",
                }.get(act, act)
                out.append((f"{prefix}{start}..{last}", act))
                i = j
                continue
        out.append((key, act))
        i += 1
    return out


def main():
    with open(CONFIG, "rb") as fh:
        cfg = tomllib.load(fh)

    main_binds = cfg.get("mode", {}).get("main", {}).get("binding", {})
    grouped = {name: [] for name, _ in GROUPS}
    for binding, cmd in main_binds.items():
        if isinstance(cmd, list):
            cmd = cmd[0]
        for name, pred in GROUPS:
            try:
                if pred(cmd):
                    grouped[name].append((pretty_key(binding), pretty_action(cmd)))
                    break
            except IndexError:
                pass

    use_color = sys.stdout.isatty()
    c = ANSI if use_color else {k: "" for k in ANSI}
    width = shutil.get_terminal_size((84, 40)).columns

    # Build one block per group, plus service mode
    blocks = []
    for name, _ in GROUPS:
        rows = collapse(sorted(set(grouped[name]), key=lambda r: (len(r[0]), r[0])))
        if rows:
            blocks.append((name, "", rows))

    svc = cfg.get("mode", {}).get("service", {}).get("binding", {})
    if svc:
        rows = [(KEYSYM.get(k, k), (v[0] if isinstance(v, list) else v))
                for k, v in svc.items()]
        blocks.append(("SERVICE MODE", "SUPER+SHIFT+;", rows))

    def render(block):
        """-> list of (plain, colored) lines for one block."""
        name, hint, rows = block
        head = f"{name}  {hint}" if hint else name
        out = [(head, f"{c['head']}{name}{c['off']}"
                      + (f"  {c['dim']}{hint}{c['off']}" if hint else ""))]
        pad = max(len(k) for k, _ in rows)
        for key, act in rows:
            plain = f"  {key:<{pad}}  |  {act}"   # must match the visible width of the colored line
            out.append((plain,
                        f"  {c['accent']}{key:<{pad}}{c['off']}"
                        f"  {c['dim']}|{c['off']}  {act}"))
        out.append(("", ""))
        return out

    rendered = [render(b) for b in blocks]
    colw = max(len(pl) for blk in rendered for pl, _ in blk) + 3

    print()
    print(f"  {c['bold']}{c['accent']}AeroSpace{c['off']}"
          f"  {c['dim']}SUPER = right Command{c['off']}")

    # Two columns when the terminal is wide enough, otherwise stack
    if width >= colw * 2 + 4:
        print(f"  {c['dim']}{'-' * min(width - 4, colw * 2)}{c['off']}")
        total = sum(len(b) for b in rendered)
        left, acc = [], 0
        for blk in rendered:            # greedy split at the halfway point
            if acc < total / 2:
                left.append(blk); acc += len(blk)
            else:
                break
        right = rendered[len(left):]
        lcol = [ln for blk in left for ln in blk]
        rcol = [ln for blk in right for ln in blk]
        for i in range(max(len(lcol), len(rcol))):
            lp, lc = lcol[i] if i < len(lcol) else ("", "")
            _, rc = rcol[i] if i < len(rcol) else ("", "")
            print(f"  {lc}{' ' * (colw - len(lp))}{rc}".rstrip())
    else:
        print(f"  {c['dim']}{'-' * min(width - 4, colw)}{c['off']}")
        for blk in rendered:
            for _, cl in blk:
                print(f"  {cl}".rstrip())
    print()


if __name__ == "__main__":
    main()
