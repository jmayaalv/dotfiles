#!/usr/bin/env bash
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "Setting up dotfiles from $DOTFILES_DIR..."

# Install Prelude (Emacs distribution) if not already present
if [ ! -d "$HOME/.emacs.d/.git" ]; then
  echo "Installing Emacs Prelude..."
  git clone https://github.com/bbatsov/prelude.git "$HOME/.emacs.d"
else
  echo "Emacs Prelude already installed, skipping."
fi

# Stow all dotfiles
echo "Stowing dotfiles..."
cd "$DOTFILES_DIR"
stow --target="$HOME" .

echo "Done. Restart your shell or run: source ~/.zshrc"
