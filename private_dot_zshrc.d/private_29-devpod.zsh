# https://ghostty.org/docs/help/terminfo
export TERMINFO="$HOME/.terminfo"

command -v omni >/dev/null && source <(omni completion zsh)

__system-upgrade() {
  cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update &&
    sudo apt upgrade -y &&
    sudo apt autoremove -y &&
    sudo apt clean -y &&
    sudo rm -rf /var/lib/apt/lists/*
}

__tools-upgrade() {
  mise self-update --yes &&
    mise plugins update &&
    mise upgrade --bump --interactive \
      --exclude=go \
      --exclude=lua \
      --exclude=node \
      --exclude=python \
      --exclude=yarn &&
    mise cache prune &&
    zim
}

__config-sync() {
  chezmoi git pull &&
    chezmoi apply --force &&
    nvim --headless \
      -c 'Lazy! restore' \
      -c MasonUpdate \
      -c MasonLockRestore \
      -c qa

  git -C "$HOME/.agents" pull origin main
}

# `devenv` is bash-only (declare -gA, printf -v, ${!var}, ${BASH_SOURCE}, bash traps/arrays)
# and sources several more bash sub-scripts, so it cannot be sourced by zsh directly.
# Instead run it under a real bash and copy the resulting exported environment back into zsh.
#
# Limitation: only exported environment variables cross over.
# Shell functions and CLI tab-completions that devenv sets up live only inside bash.
__devenv() {
  emulate -L zsh

  if [[ ! -r devenv ]]; then
    print -u2 "devenv: no readable devenv in $PWD (run from the repo root)"
    return 1
  fi

  local rc dump name value
  dump=$(mktemp) || return 1

  {
    # Run the bash-only script under bash:
    #  - devenv stdout -> stderr (1>&2) so its logs/spinner don't pollute the dump
    #  - stdin/stderr stay on the tty so interactive logins still prompt
    #  - capture devenv's own status in `rc` BEFORE running anything else,
    #    then `exit $rc` so the subshell propagates it (env -0 would otherwise mask it)
    #  - `trap - EXIT` neutralizes devenv's EXIT trap, which would otherwise
    #    rm the temp files the instant this subshell exits
    #  - `env -0` writes the post-source environment (NUL-delimited) to the dump
    bash -c 'source devenv 1>&2; rc=$?; trap - EXIT; env -0; exit $rc' >| "$dump"
    rc=$?

    # Import each exported var into zsh, skipping shell-managed / read-only ones.
    # `export` is non-fatal so one bad var can't abort the whole import.
    while IFS='=' read -r -d '' name value; do
      case $name in
        (SHLVL|PWD|OLDPWD|_|SHELL|PS1|PS2|PROMPT|IFS|LINES|COLUMNS|EUID|EGID|UID|GID|BASH*|ZSH_*) continue ;;
      esac
      export "$name=$value" 2>/dev/null \
        || print -u2 "devenv: skipped read-only/invalid var: $name"
    done < "$dump"

    bash -c 'make environment && make environments-env'
  } always {
    rm -f "$dump"
  }

  return $rc
}

alias ak='goak'
