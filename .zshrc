if [[ -f "/opt/homebrew/bin/brew" ]] then
   # If you're using macOS, you'll want this enabled
   eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# this is a solution to emacs tramp timeout problem
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ '

export PATH=$HOME/bin:/usr/local/bin:/Applications/Tools/apache-maven-3.6.3/bin:$PATH
export JAVA_HOME=${SDKMAN_CANDIDATES_DIR}/java/${CURRENT}

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

# Load completions
autoload -Uz compinit && compinit

zinit cdreplay -q

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
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Shell integrations
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"

# aliases

# aliases

# exits
exists() {
  type $1 > /dev/null 2>&1
}

is_osx() {
  if [[ "$(uname)" == "Darwin" ]]; then
    return 0
  else
    return 1
  fi
}


alias vi='vim'
alias cat='bat'
alias ls='ls --color'
alias clj-new='clojure -X:new :name'
alias clj-new-lib='clojure -X:new  :template lib :name'

alias tlocal='tmux new -s local'
alias attach='tmux attach-session -t'

alias federer='tmuxinator start federer'

alias medusa='tmuxinator start medusa'
alias tom='tmuxinator start tom'

alias axonic-test='tmuxinator start axonic_test'
alias lic-test='tmuxinator start lic_test'
alias agl-test='tmuxinator start agl_test'
alias allangray-prod='tmuxinator start allangray_prod'
alias allangray-test='tmuxinator start allangray_test'
alias glacier-test='tmuxinator start glacier_test'
alias omi-test='tmuxinator start omi_test'
alias veritas-test='tmuxinator start veritas_test'
alias prospero-test='tmuxinator start prospero_test'
alias plac-test='tmuxinator start plac_test'
alias sgis-test='tmuxinator start sgis_test'
alias oic-test='tmuxinator start oic_test'
alias secura-test='tmuxinator start secura_test'
alias provlife-test='tmuxinator start provlife_test'
alias gosaver-test='tmuxinator start gosaver_test'
alias sbi-test='tmuxinator start sbi_test'
alias fnb-test='tmuxinator start fnb_test'
alias axonic-prod='tmuxinator start axonic_prod'
alias argus-prod='tmuxinator start argus_prod'
alias lic-prod='tmuxinator start lic_prod'
alias nav-prod='tmuxinator start nav_prod'
alias omnia-prod='tmuxinator start omnia_prod'
alias agl-prod='tmuxinator start agl_prod'
alias glacier-prod='tmuxinator start glacier_prod'
alias oic-prod='tmuxinator start oic_prod'
alias gosaver-prod='tmuxinator start gosaver_prod'
alias omi-prod='tmuxinator start omi_prod'
alias sgis-prod='tmuxinator start sgis_prod'
alias plac-prod='tmuxinator start plac_prod'
alias provlife-prod='tmuxinator start provlife_prod'
alias prospero-prod='tmuxinator start prospero_prod'
alias veritas-prod='tmuxinator start veritas_prod'
alias propsero-prod='tmuxinator start prospero_prod'
alias secura-prod='tmuxinator start secura_prod'
alias sbi-prod='tmuxinator start sbi_prod'
