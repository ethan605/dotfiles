# vim:filetype=zsh

# Zimfw
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR:-$HOME}/.zimrc" ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  # shellcheck disable=SC1091
  source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# shellcheck disable=SC1091
source "${ZIM_HOME}/init.zsh"

# System plugins
eval "$(direnv hook zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# Mise plugins
eval "$(mise activate zsh)"
eval "$(gt completion)"
eval "$(helm completion zsh)"
# shellcheck disable=SC1091
source "$(mise where gcloud)/completion.zsh.inc"
