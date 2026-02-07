# vim:filetype=zsh

# Mise and mise-related
eval "$(mise activate zsh)"

# TODO: clean-up when all system packages are migrated away from mise
export PATH="/etc/profiles/per-user/$USER/bin:$PATH"

# Zimfw
if [[ ! "${ZIM_HOME}/init.zsh" -nt "${ZDOTDIR:-$HOME}/.zimrc" ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  # shellcheck disable=SC1091
  source "${ZIM_HOME}/zimfw.zsh" init -q
fi

# shellcheck disable=SC1091
source "${ZIM_HOME}/init.zsh"

# shellcheck disable=SC1091
source "$(mise where gcloud)/completion.zsh.inc"

# Other plugins
eval "$(direnv hook zsh)"
eval "$(helm completion zsh)"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
