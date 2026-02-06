# vim:filetype=zsh
export WORK_DIR="$HOME/work"

if [[ -f "$WORK_DIR/.zshrc" ]]; then
  # shellcheck disable=SC1091
  source "$WORK_DIR/.zshrc"
fi

alias wpass='PASSWORD_STORE_DIR="$WORK_DIR/.password-store" pass'
