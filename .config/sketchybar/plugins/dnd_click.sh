#!/usr/bin/env bash

# Nothing on macOS sets a Focus from the command line, so hand over the pane
# that can. Opening it is idempotent - a second click just refocuses it.
open "x-apple.systempreferences:com.apple.Focus-Settings.extension"
