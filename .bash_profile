# The following lines were added by Docker Desktop to add commands to your PATH.
export PATH="$PATH:/Users/jmayaalv/.docker/bin"
# End of Docker Desktop section.

eval "$(zoxide init --cmd cd bash)"

#THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
export SDKMAN_DIR="$HOME/.sdkman"
[[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"
. "$HOME/.cargo/env"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/jmayaalv/.lmstudio/bin"
# End of LM Studio CLI section

