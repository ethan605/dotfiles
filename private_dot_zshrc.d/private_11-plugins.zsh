# vim:filetype=zsh
# === Cached tool inits - setup ===
_zcache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh"
[[ -d $_zcache ]] || mkdir -p "$_zcache"

__load-mise() {
  if (( ${+commands[mise]} )); then
    if [[ ! $_zcache/mise.zsh -nt ${commands[mise]} ]]; then
      mise activate zsh >| "$_zcache/mise.zsh"
      zcompile -R "$_zcache/mise.zsh" 2>/dev/null
    fi
    source "$_zcache/mise.zsh"
  fi
}

__load-zim() {
  export ZIM_HOME="${ZDOTDIR:-$HOME}/.zim"

  if [[ ! "$ZIM_HOME/init.zsh" -nt "${ZDOTDIR:-$HOME}/.zimrc" ]]; then
    source "$ZIM_HOME/zimfw.zsh" init -q
  fi

  source "$ZIM_HOME/init.zsh"

  alias zim='zimfw upgrade &&
    zimfw update &&
    zimfw clean &&
    zimfw build &&
    zimfw compile &&
    rm -rf $XDG_CACHE_HOME/zsh/*.zsh*'
}

__autocmp-devpod() {
  if (( ${+commands[devpod]} )); then
    if [[ ! $_zcache/devpod.zsh -nt ${commands[devpod]} ]]; then
      devpod completion zsh >| "$_zcache/devpod.zsh"
      zcompile -R "$_zcache/devpod.zsh" 2>/dev/null
    fi
    source "$_zcache/devpod.zsh"
  fi
}

__autocmp-gcloud() {
  local gcloud_dir=$(mise where gcloud 2>/dev/null)

  if [[ -d $gcloud_dir ]]; then
    source "$gcloud_dir/completion.zsh.inc"
    source "$gcloud_dir/path.zsh.inc"
  fi
}

__autocmp-gh() {
  if (( ${+commands[gh]} )); then
    if [[ ! $_zcache/gh.zsh -nt ${commands[gh]} ]]; then
      gh completion -s zsh >| "$_zcache/gh.zsh"
      zcompile -R "$_zcache/gh.zsh" 2>/dev/null
    fi
    source "$_zcache/gh.zsh"
  fi
}

__autocmp-gt() {
  if (( ${+commands[gt]} )); then
    if [[ ! $_zcache/gt.zsh -nt ${commands[gt]} ]]; then
      gt completion >| "$_zcache/gt.zsh"
      zcompile -R "$_zcache/gt.zsh" 2>/dev/null
    fi
    source "$_zcache/gt.zsh"
  fi
}

__autocmp-helm() {
  if (( ${+commands[helm]} )); then
    if [[ ! $_zcache/helm.zsh -nt ${commands[helm]} ]]; then
      helm completion zsh >| "$_zcache/helm.zsh"
      zcompile -R "$_zcache/helm.zsh" 2>/dev/null
    fi
    source "$_zcache/helm.zsh"
  fi
}

__autocmp-kubectl() {
  if (( ${+commands[kubectl]} )); then
    if [[ ! $_zcache/kubectl.zsh -nt ${commands[kubectl]} ]]; then
      kubectl completion zsh >| "$_zcache/kubectl.zsh"
      zcompile -R "$_zcache/kubectl.zsh" 2>/dev/null
    fi
    source "$_zcache/kubectl.zsh"

    if (( ${+commands[kubecolor]} )); then
      alias kubectl=kubecolor
      alias k=kubectl

      compdef kubecolor=kubectl
    fi
  fi
}

__autocmp-opencode() {
  if (( ${+commands[opencode]} )); then
    if [[ ! $_zcache/opencode.zsh -nt ${commands[opencode]} ]]; then
      opencode completion >| "$_zcache/opencode.zsh"
      zcompile -R "$_zcache/opencode.zsh" 2>/dev/null
    fi
    source "$_zcache/opencode.zsh"

    compdef __oc=opencode
    compdef ocw=opencode
    compdef ocp=opencode
  fi
}

__autocmp-uv-uvx() {
  if (( ${+commands[uv]} )); then
    if [[ ! $_zcache/uv.zsh -nt ${commands[uv]} ]]; then
      uv generate-shell-completion zsh >| "$_zcache/uv.zsh"
      zcompile -R "$_zcache/uv.zsh" 2>/dev/null
    fi
    source "$_zcache/uv.zsh"
  fi

  if (( ${+commands[uvx]} )); then
    if [[ ! $_zcache/uvx.zsh -nt ${commands[uvx]} ]]; then
      uvx --generate-shell-completion zsh >| "$_zcache/uvx.zsh"
      zcompile -R "$_zcache/uvx.zsh" 2>/dev/null
    fi
    source "$_zcache/uvx.zsh"
  fi
}

__autocmp-vivid() {
  if (( ${+commands[vivid]} )); then
    if [[ ! $_zcache/ls-colors.zsh -nt ${commands[vivid]} ]]; then
      print -r -- "export LS_COLORS='$(vivid generate base16-snazzy)'" >| "$_zcache/ls-colors.zsh"
      zcompile -R "$_zcache/ls-colors.zsh" 2>/dev/null
    fi
    source "$_zcache/ls-colors.zsh"
  fi
}

__autocmp-ykman() {
  if (( ${+commands[ykman]} )); then
    if [[ ! $_zcache/ykman.zsh -nt ${commands[ykman]} ]]; then
      _YKMAN_COMPLETE=zsh_source ykman >| "$_zcache/ykman.zsh"
      zcompile -R "$_zcache/ykman.zsh" 2>/dev/null
    fi
    source "$_zcache/ykman.zsh"
  fi
}

__autocmp-zoxide() {
  if (( ${+commands[zoxide]} )); then
    if [[ ! $_zcache/zoxide.zsh -nt ${commands[zoxide]} ]]; then
      zoxide init zsh >| "$_zcache/zoxide.zsh"
      zcompile -R "$_zcache/zoxide.zsh" 2>/dev/null
    fi
    source "$_zcache/zoxide.zsh"
  fi
}

__load-mise
__load-zim
# __autocmp-devpod
# __autocmp-gcloud
__autocmp-gh
__autocmp-gt
__autocmp-helm
__autocmp-kubectl
__autocmp-opencode
__autocmp-uv-uvx
__autocmp-vivid
__autocmp-ykman
__autocmp-zoxide

# === Cached tool inits - tear-down ===
unset _zcache

# Expensive executions - use on demand
__autocmp-on-demand() {
  if (( ${+commands[register-python-argcomplete]} )); then
    source <(register-python-argcomplete --shell=zsh pytest pytest-xdist)
  fi

  # Bash completions
  autoload -U +X bashcompinit && bashcompinit
  (( ${+commands[aws_completer]} )) && complete -o nospace -C "$(which aws_completer)" aws
  (( ${+commands[terraform]} )) && complete -o nospace -C "$(which terraform)" terraform
}
