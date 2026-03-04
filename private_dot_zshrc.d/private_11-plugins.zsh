# vim:filetype=zsh

# Zimfw
if [[ ! "$ZIM_HOME/init.zsh" -nt "${ZDOTDIR:-$HOME}/.zimrc" ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  source "$ZIM_HOME/zimfw.zsh" init -q
fi

source "$ZIM_HOME/init.zsh"

# System plugins
source <(devpod completion zsh)
source <(direnv hook zsh)
source <(starship init zsh)
source <(zoxide init zsh)

# Mise plugins
source <(mise activate zsh)
source <(gt completion)
source <(helm completion zsh)
source "$(mise where gcloud)/completion.zsh.inc"
