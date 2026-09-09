#!/usr/bin/env bash
#
# Open a new Chrome window in the *focused* workspace.
#
# Three things have to line up, and dropping any one of them lands you back in
# whichever workspace already holds a Chrome window:
#
#   -n                    Plain `open -a` on a running Chrome is an activate,
#                         not a launch: it raises the existing window and
#                         AeroSpace follows focus out of the workspace you are
#                         standing in. Same flag, same reason, as scratchpad.sh.
#   --new-window          -n alone is not enough. The second process finds
#                         Chrome's singleton lock, hands its command line to the
#                         running instance and exits; with no arguments to hand
#                         over that is a no-op once Chrome has any window open.
#   --profile-directory   With more than one profile and no profile named,
#                         --new-window opens the "Who's using Chrome?" picker
#                         instead of a window - and choosing a profile there
#                         activates that profile's existing window rather than
#                         making a new one. Which is the yank all over again.
#
# The profile is read rather than hardcoded so that this follows you between
# personal and work: whichever one Chrome last used is the one you get.

set -uo pipefail

LOCAL_STATE="$HOME/Library/Application Support/Google/Chrome/Local State"

# `profile.last_used` is the directory name ("Default", "Profile 1"), not the
# display name. Missing file, unreadable JSON or a single-profile install all
# fall through to Default, which is the profile every Chrome has.
profile="$(python3 -c '
import json, sys
try:
    with open(sys.argv[1]) as f:
        print(json.load(f)["profile"]["last_used"])
except Exception:
    print("Default")
' "$LOCAL_STATE" 2>/dev/null)"
: "${profile:=Default}"

open -na "Google Chrome" --args --profile-directory="$profile" --new-window
