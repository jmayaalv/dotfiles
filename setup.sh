#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  Darwin) OS=macos ;;
  Linux) OS=linux ;;
  *) echo "Unsupported OS: $(uname -s)" >&2; exit 1 ;;
esac

echo "Setting up dotfiles from $DOTFILES_DIR ($OS)..."

if [ "$OS" = macos ]; then

# Homebrew packages come from tools/Brewfile. `brew bundle` is idempotent and
# skips anything already installed, so the per-tool `command -v` guards this
# block used to carry are no longer needed.
#
# Regenerate the Brewfile from what is actually installed with
# tools/save-packages.
#
# Developer tooling that mise owns (clojure, java, node, gh, ...) is not in the
# Brewfile — mise installs it below on both platforms.
command -v brew >/dev/null || {
  echo "Homebrew not found. Install it from https://brew.sh and re-run." >&2
  exit 1
}
echo "Installing Homebrew packages..."
brew bundle install --file="$DOTFILES_DIR/tools/Brewfile"

else # Linux (Omarchy)

# System and desktop packages come from tools/packages.txt, which is generated
# from what this machine has beyond a stock Omarchy install. Regenerate it with
# tools/save-packages after installing something worth keeping.
#
# Developer tooling (clojure, java, node, gh, ...) is NOT here — mise owns that,
# below, because mise works identically on macOS. Installing e.g. github-cli via
# pacman would just be shadowed by mise's copy on PATH.
echo "Installing packages..."
pkgs=$(grep -vE '^\s*(#|$)' "$DOTFILES_DIR/tools/packages.txt")
if command -v omarchy &>/dev/null; then
  # shellcheck disable=SC2086
  omarchy pkg add $pkgs
else
  # shellcheck disable=SC2086
  sudo pacman -S --needed $pkgs
fi

fi

# Developer tooling, from .config/mise/config.toml. mise is cross-platform, so
# this is the one place clojure/java/node/gh versions are defined for every
# machine — the OS package managers above deliberately do not install them.
if command -v mise &>/dev/null; then
  echo "Installing dev tools via mise..."
  mise install
else
  echo "mise not found. Install it (https://mise.jdx.dev) and re-run to get"
  echo "clojure, java, node, gh and friends."
fi

# Install Prelude (Emacs distribution) if not already present
if [ ! -d "$HOME/.emacs.d/.git" ]; then
  echo "Installing Emacs Prelude..."
  git clone https://github.com/bbatsov/prelude.git "$HOME/.emacs.d"
else
  echo "Emacs Prelude already installed, skipping."
fi

# Install TPM (Tmux Plugin Manager)
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "TPM already installed, skipping."
else
  echo "Installing TPM..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

# Stow all dotfiles
echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"

# On Omarchy, alacritty.toml is owned by the distro: it is an importer pointing
# at the active theme's generated colors. Stowing the macOS version (which
# hardcodes colors) breaks theming, and --adopt below would pull the importer
# into the repo on top of the macOS file. Leave it to Omarchy.
# Files in the root package that stay macOS-only. stow matches a pattern
# containing "/" against the full package-relative path; a pattern without one
# is matched against the basename, so '^alacritty$' silently matches nothing —
# verified with `stow -n -v`.
stow_args=()
if [ "$OS" = linux ]; then
  stow_args=(
    # Omarchy owns this: it imports the active theme's generated colors,
    # whereas the macOS version hardcodes them.
    --ignore='^\.config/alacritty/alacritty\.toml$'
    # Omarchy ships its own /etc/skel versions of these.
    --ignore='^\.bash_profile$'
    --ignore='^\.config/tmux/tmux\.conf$'
    # Machine-local: hooks reference macOS-only tooling.
    --ignore='^\.claude/settings\.json$'
    # Prelude writes this one directly into ~/.emacs.d/personal.
    # prelude-modules.el is deliberately NOT ignored: it is the real module
    # list (clojure, key-chord), and Prelude's stock default omits
    # prelude-clojure, so cider never installs and personal/clojure.el then
    # fails on (require 'cider) — aborting the load of every personal file
    # after it.
    --ignore='^\.emacs\.d/personal/preload/\.gitkeep$'
  )
fi

stow "${stow_args[@]}" --target="$HOME" .

# Adopt any real files that should be managed by stow.
# This handles the case where directories like ~/.emacs.d/personal/ already exist
# (e.g. from Prelude clone) and files were created there directly instead of in the
# dotfiles repo. --adopt moves the real file into the repo and replaces it with a symlink.
# --adopt moves the file that is already on disk INTO the repo. That is what we
# want on macOS, where a conflicting file is something Prelude or an app wrote.
# It is wrong on Omarchy, where ~/.bash_profile and ~/.config/tmux/tmux.conf are
# pristine /etc/skel copies: adopting them would overwrite the real macOS
# versions in this repo and push distro defaults to every other machine.
# On Linux, plain stow aborts on conflict instead — resolve those by hand.
if [ "$OS" = macos ]; then
  echo "Adopting any unmanaged files into stow..."
  stow --adopt --target="$HOME" .
fi

# Omarchy desktop config lives in its own stow package so `stow .` on macOS
# never sees it. See .stow-local-ignore.
if [ "$OS" = linux ] && command -v omarchy &>/dev/null; then
  echo "Stowing Omarchy config..."
  # Create these first: if they don't exist, stow folds the whole tree into a
  # single symlink and Omarchy can no longer write plugins/, hooks/, themes/.
  mkdir -p "$HOME/.config/hypr" "$HOME/.config/omarchy/themed" \
    "$HOME/.config/omarchy/backgrounds" "$HOME/.local/bin"
  stow --target="$HOME" omarchy

  # Machine-specific: display scaling and pointer tuning for an aarch64 QEMU VM.
  # Wrong on real hardware, so opt in with DOTFILES_VM=1.
  if [ "${DOTFILES_VM:-0}" = 1 ]; then
    echo "Stowing VM-specific config..."
    stow --target="$HOME" omarchy-vm
  fi

  # Renders .config/omarchy/themed/*.tpl, including fuzzel.ini.
  omarchy theme set "$(omarchy theme current)" || true
  hyprctl reload
  errors=$(hyprctl configerrors 2>&1 || true)
  if [ -n "${errors// /}" ]; then
    echo "Hyprland config errors:" >&2
    echo "$errors" >&2
    exit 1
  fi
  echo "Hyprland config OK. SUPER+Z / SUPER+ALT+Z switch windows."
fi

echo "Done. Restart your shell or run: source ~/.zshrc"
