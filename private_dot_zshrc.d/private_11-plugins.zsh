# vim:filetype=zsh
source <(mise activate zsh)

# === Zimfw ===
if [[ ! "$ZIM_HOME/init.zsh" -nt "${ZDOTDIR:-$HOME}/.zimrc" ]]; then
  # Update static initialization script if it does not exist or it's outdated, before sourcing it
  source "$ZIM_HOME/zimfw.zsh" init -q
fi

source "$ZIM_HOME/init.zsh"

# === System plugins ===
source <(zoxide init zsh)

LS_COLORS="$(vivid generate base16-snazzy)"
export LS_COLORS

# === Expensive executions - use on demand ==
__source-completions() {
  command -v devpod >/dev/null && source <(devpod completion zsh)
  command -v gh >/dev/null && source <(gh completion -s zsh)
  command -v gt >/dev/null && source <(gt completion)
  command -v helm >/dev/null && source <(helm completion zsh)
  command -v opencode >/dev/null && source <(opencode completion)
  command -v uv >/dev/null && source <(uv generate-shell-completion zsh)
  command -v uvx >/dev/null && source <(uvx --generate-shell-completion zsh)
  command -v ykman >/dev/null && source <(_YKMAN_COMPLETE=zsh_source ykman)

  local gcloud_dir=$(mise where gcloud 2>/dev/null)

  if [[ -d $gcloud_dir ]]; then
    source "$gcloud_dir/completion.zsh.inc"
    source "$gcloud_dir/path.zsh.inc"
  fi

  command -v register-python-argcomplete >/dev/null &&
    source <(register-python-argcomplete --shell=zsh pytest pytest-xdist)

  command -v terraform >/dev/null && complete -o nospace -C "$(which terraform)" terraform

  autoload -U +X bashcompinit && bashcompinit
  command -v aws_completer >/dev/null && complete -C "$(which aws_completer)" aws
}
