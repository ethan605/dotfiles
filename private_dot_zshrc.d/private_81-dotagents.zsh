export OPENCHAMBER_SKIP_LOCAL_SERVER=1

alias dcompose='docker compose'
alias dagents='docker compose -p dotagents'
alias dtests='docker compose -p dotagents-tests'
alias dbnc='dagents build --no-cache'
alias dexec='dagents exec'
alias dup='dagents up -d --force-recreate -t0'
alias ddn='dagents down -t0'

dbx() {
  (
    set -a
    source "$HOME/.docker-sandbox-client/.envrc"
    set +a

    docker "$@"
  )
}
compdef dbx=docker

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
