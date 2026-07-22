alias nix-stat='sudo darwin-rebuild --list-generations'
alias nix-switch='sudo darwin-rebuild switch --flake $HOME/.config/nix-darwin'
alias nix-update='nix flake update --flake $HOME/.config/nix-darwin'

__nix-args() {
  if [[ $# == 1 ]]; then
    echo "nixpkgs#$1"
  else
    echo "nixpkgs/$1#$2"
  fi
}

nix-bld() {
  local args=$(__nix-args "$@")
  sudo nix build --repair "$args"
}

nix-gc() {
  local arg=${1:-}

  if [[ $arg == "all" ]]; then
    sudo nix-collect-garbage --delete-old && nix-collect-garbage --delete-old
  else
    sudo nix-collect-garbage --delete-older-than 1d && nix-collect-garbage --delete-older-than 1d
  fi
}

nix-ls() {
  local args=$(__nix-args "$@")
  nix eval --raw "$args"
}

nix-search() {
  if [[ $# == 1 ]]; then
    nix search nixpkgs "$1"
  else
    nix search "nixpkgs/$1" "$2"
  fi
}

nix-sh() {
  if [[ $# == 1 ]]; then
    nix-shell --command "$SHELL" --packages "$1"
  else
    local search_path="nixpkgs=https://github.com/NixOS/nixpkgs/archive/$1.tar.gz"
    nix-shell -I "$search_path" --command "$SHELL" --packages "$2"
  fi
}
