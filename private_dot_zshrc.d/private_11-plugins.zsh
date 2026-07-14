# vim:filetype=zsh
# Dedupe path/fpath
typeset -U path fpath

# Fast completion init
autoload -Uz compinit
_zdump="${ZDOTDIR:-$HOME}/.zcompdump-${ZSH_VERSION}"
_zfresh=( ${_zdump}(Nmh-24) )          # non-empty only if dump exists AND <24h old
if (( $#_zfresh )); then
  compinit -C -d "$_zdump"             # reuse cached dump, no audit (~10ms)
else
  compinit -d "$_zdump"                # rebuild + re-scan fpath (once/day, or first run)
fi
[[ ! ${_zdump}.zwc -nt $_zdump ]] && zcompile -R "$_zdump" 2>/dev/null
unset _zdump _zfresh

# Cached tool inits
_zcache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $_zcache ]] || mkdir -p "$_zcache"

# mise
if (( ${+commands[mise]} )); then
  if [[ ! $_zcache/mise.zsh -nt ${commands[mise]} ]]; then
    mise activate zsh >| "$_zcache/mise.zsh"
    zcompile -R "$_zcache/mise.zsh" 2>/dev/null
  fi
  source "$_zcache/mise.zsh"
fi

# === Zimfw ===
if [[ ! "$ZIM_HOME/init.zsh" -nt "${ZDOTDIR:-$HOME}/.zimrc" ]]; then
  source "$ZIM_HOME/zimfw.zsh" init -q
fi

source "$ZIM_HOME/init.zsh"

# === System plugins ===
if (( ${+commands[zoxide]} )); then
  if [[ ! $_zcache/zoxide.zsh -nt ${commands[zoxide]} ]]; then
    zoxide init zsh >| "$_zcache/zoxide.zsh"
    zcompile -R "$_zcache/zoxide.zsh" 2>/dev/null
  fi
  source "$_zcache/zoxide.zsh"
fi

# LS_COLORS via vivid
if (( ${+commands[vivid]} )); then
  if [[ ! $_zcache/ls-colors.zsh -nt ${commands[vivid]} ]]; then
    print -r -- "export LS_COLORS='$(vivid generate base16-snazzy)'" >| "$_zcache/ls-colors.zsh"
    zcompile -R "$_zcache/ls-colors.zsh" 2>/dev/null
  fi
  source "$_zcache/ls-colors.zsh"
fi
unset _zcache

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
