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

# Install GitHub CLI
if command -v gh &>/dev/null; then
  echo "GitHub CLI already installed, skipping."
else
  echo "Installing GitHub CLI..."
  brew install gh
fi

# Install pandoc
if command -v pandoc &>/dev/null; then
  echo "pandoc already installed, skipping."
else
  echo "Installing pandoc..."
  brew install pandoc
fi

# Install Fira Code font
if fc-list | grep -qi "Fira Code"; then
  echo "Fira Code font already installed, skipping."
else
  echo "Installing Fira Code font..."
  brew install --cask font-fira-code
fi

# Install Bun
if command -v bun &>/dev/null; then
  echo "Bun already installed, skipping."
else
  echo "Installing Bun..."
  brew tap oven-sh/bun && brew install bun
fi

# Install Leiningen
if command -v lein &>/dev/null; then
  echo "Leiningen already installed, skipping."
else
  echo "Installing Leiningen..."
  brew install leiningen
fi

# Install bat
if command -v bat &>/dev/null; then
  echo "bat already installed, skipping."
else
  echo "Installing bat..."
  brew install bat
fi

# Install libvterm (needed by Emacs vterm)
if brew list libvterm &>/dev/null; then
  echo "libvterm already installed, skipping."
else
  echo "Installing libvterm..."
  brew install libvterm
fi

# Install cmake (needed to build vterm module)
if command -v cmake &>/dev/null; then
  echo "cmake already installed, skipping."
else
  echo "Installing cmake..."
  brew install cmake
fi

# Install clojure-lsp
if command -v clojure-lsp &>/dev/null; then
  echo "clojure-lsp already installed, skipping."
else
  echo "Installing clojure-lsp..."
  brew install clojure-lsp/brew/clojure-lsp-native
fi

else # Linux (Omarchy)

# Omarchy wraps pacman and is a no-op for packages already present, so the
# per-tool `command -v` guards the macOS branch needs aren't required here.
#
# Not in the Arch repos for this arch: pandoc, bun, clojure-lsp. Install those
# by hand if you need them.
echo "Installing packages..."
if command -v omarchy &>/dev/null; then
  omarchy pkg add stow fuzzel jq librsvg github-cli ttf-fira-code \
    leiningen bat clojure libvterm cmake
else
  sudo pacman -S --needed stow fuzzel jq librsvg github-cli ttf-fira-code \
    leiningen bat clojure libvterm cmake
fi

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
# stow matches a pattern containing "/" against the full package-relative path,
# so this excludes exactly that one file and still links the sibling theme
# files. A bare '^alacritty$' silently matches nothing — verified with -n -v.
stow_args=()
if [ "$OS" = linux ]; then
  stow_args=(--ignore='^\.config/alacritty/alacritty\.toml$')
fi

stow "${stow_args[@]}" --target="$HOME" .

# Adopt any real files that should be managed by stow.
# This handles the case where directories like ~/.emacs.d/personal/ already exist
# (e.g. from Prelude clone) and files were created there directly instead of in the
# dotfiles repo. --adopt moves the real file into the repo and replaces it with a symlink.
echo "Adopting any unmanaged files into stow..."
stow --adopt "${stow_args[@]}" --target="$HOME" .

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
