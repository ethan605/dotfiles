export OPENCHAMBER_SKIP_LOCAL_SERVER=1

alias dcompose='docker compose -p dotagents'
alias dexec='dcompose exec'

dwd() {
  local container_dir=/home/opencode/data
  local pwd=$(pwd)

  local variant
  case "$pwd" in
    $HOME/.agents*) variant=personal host_dir="$HOME" ;;
    $HOME/personal/*) variant=personal host_dir="$HOME/$variant" ;;
    $HOME/work/*) variant=work host_dir="$HOME/$variant" ;;
  esac 

  if [[ -z $variant ]]; then
    echo "Invalid working dir, expecting either $HOME/.agents, $HOME/personal or $HOME/work"
    return 1
  fi

  local workdir=${${pwd}/${host_dir}/${container_dir}}

  if [[ $# < 1 ]]; then
    dexec -w "$workdir" "opencode-$variant" /bin/bash
  else
    dexec -w "$workdir" "opencode-$variant" "$@"
  fi
}

alias oc1='XDG_CONFIG_HOME="$HOME/.oc1" XDG_DATA_HOME="$HOME/.oc1/data" XDG_STATE_HOME="$HOME/.oc1/state" XDG_CACHE_HOME="$HOME/.oc1/cache" "$HOME/.local/share/mise/installs/opencode/latest/opencode"'
