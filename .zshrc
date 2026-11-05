if [[ -f "/opt/homebrew/bin/brew" ]] then
   # If you're using macOS, you'll want this enabled
   eval "$(/opt/homebrew/bin/brew shellenv)"
fi

#java home
export SDKMAN_DIR="$HOME/.sdkman"
export JAVA_HOME=${SDKMAN_DIR}/candidates/java/current
export ATLASSIAN_USER_EMAIL="juan.maya@kane-group.com"
# Load Atlassian API token from secure location
if [ -f ~/.secrets/atlassian_token ]; then
  export ATLASSIAN_API_TOKEN=$(cat ~/.secrets/atlassian_token)
fi


# Catppuccinno machiato for fzf
export FZF_DEFAULT_OPTS=" \
--color=bg+:#252832,bg:#161821,spinner:#C4A5A5,hl:#BD5766 \
--color=fg:#9AA3C5,header:#BD5766,info:#9670C6,pointer:#C4A5A5 \
--color=marker:#878DA8,fg+:#9AA3C5,prompt:#9670C6,hl+:#BD5766 \
--color=selected-bg:#343744 \
--color=border:#4E535D,label:#9AA3C5"


# this is a solution to emacs tramp timeout problem
[[ $TERM == dumb ]] && unsetopt zle && PS1="$ "

# Temp workaround to disable punycode deprecation logging to stderr
# https://github.com/bitwarden/clients/issues/6689
export NODE_OPTIONS="--no-deprecation"

# Set the directory we want to store zinit and plugins
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"

# Download Zinit, if it's not there yet
if [ ! -d "$ZINIT_HOME" ]; then
    mkdir -p "$(dirname $ZINIT_HOME)"
    git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi

# Source/Load zinit
source "${ZINIT_HOME}/zinit.zsh"

# Add in zsh plugins
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab
zinit snippet OMZP::command-not-found

#theme for zsh-syntax-highlighting
source ~/.config/zsh/catppuccin_macchiato-zsh-syntax-highlighting.zsh

# Docker CLI completions (written by Docker Desktop; absent on plain Linux Docker).
[[ -d $HOME/.docker/completions ]] && fpath=($HOME/.docker/completions $fpath)

# Load completions. The only compinit: each one more, run with another fpath,
# found the cache stale and rebuilt it, ~2s a shell, so new herdr tabs took 10s.
# Anything that adds to fpath goes above this.
autoload -Uz compinit && compinit

zinit cdreplay -q

# sdkman runs its own compinit unless one already ran.
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
# The prompt: Omarchy's starship, see ~/.config/starship.toml. Not for TERM=dumb
# (Emacs TRAMP), which needs the plain "$ " prompt set near the top.
[[ $TERM != dumb ]] && eval "$(starship init zsh)"


# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':completion:*' format $'\e[2;37mCompleting %d\e[m'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:*' fzf-flags --bind=tab:accept
zstyle ':fzf-tab:*' continuous-trigger 'tab'
# Seed the search with what the candidates share, never the typed word: carapace
# keeps the folder in the word (vim dir/<Tab>), which no file name matches.
zstyle ':fzf-tab:*' query-string prefix



if command -v carapace >/dev/null; then
  export CARAPACE_BRIDGES='zsh,fish,bash,inshellisense' # optional
  source <(carapace _carapace)
fi

#Common aliases
alias main='tmux new -s main'
alias mini='tmux new -s mini'
alias vi='vim'
alias ls='eza'
alias clj-new='clojure -X:new :name'
alias clj-new-lib='clojure -X:new  :template lib :name'
alias tlocal='tmux new -s local'
alias attach='tmux attach-session -t'
alias claude-ch='claude --channels "plugin:telegram@claude-plugins-official"'
alias cat='bat'

# OS-specific configurations: Emacs/ec, paths and tools that differ per OS.
if [[ "$OSTYPE" == "darwin"* ]]; then
    # mac specific settings
    source ~/.config/zsh/zshrc.mac
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # Linux specific settings
    source ~/.config/zsh/zshrc.linux
fi

# Shell integrations
eval "$(fzf --zsh)"
export _ZO_DOCTOR=0
eval "$(zoxide init --cmd cd zsh)"
# Docker Desktop's completions block sits above compinit.
