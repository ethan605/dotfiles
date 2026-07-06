# https://ghostty.org/docs/help/terminfo
export TERMINFO="$HOME/.terminfo"

command -v kubectl >/dev/null && source <(kubectl completion zsh)
command -v omni >/dev/null && source <(omni completion zsh)

__system-upgrade() {
  cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update &&
    sudo apt upgrade -y &&
    sudo apt autoremove -y &&
    sudo apt clean -y &&
    sudo rm -rf /var/lib/apt/lists/*
}

__mise-upgrade() {
  mise self-update --yes &&
    mise plugins update &&
    mise upgrade --bump --interactive &&
    mise cache prune
}

__config-sync() {
  chezmoi git pull &&
    chezmoi apply --force &&
    nvim --headless \
      -c 'Lazy! restore' \
      -c MasonUpdate \
      -c MasonLockRestore \
      -c qa
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

oc() {
  # Stable features
  export OPENCODE_DISABLE_CLAUDE_CODE=true
  export OPENCODE_DISABLE_LSP_DOWNLOAD=true
  export OPENCODE_DISABLE_TERMINAL_TITLE=true
  export OPENCODE_ENABLE_EXA=true

  # Experimental features
  export OPENCODE_EXPERIMENTAL=true
  export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=true
  export OPENCODE_EXPERIMENTAL_LSP_TOOL=true
  export OPENCODE_EXPERIMENTAL_PARALLEL=true

  # For LSP servers
  export PATH="$HOME/.local/share/nvim/mason/bin:$HOME/.local/share/mise/shims:$PATH"

  # For Gemini
  GOOGLE_VERTEX_PROJECT=$(gcloud config get project)
  export GOOGLE_VERTEX_PROJECT
  export GOOGLE_VERTEX_LOCATION=global
  export VERTEX_LOCATION=global

  # For neo4j-cypher MCP
  export NEO4J_URI="$OC_NEO4J_URI"
  export NEO4J_USERNAME="$OC_NEO4J_USERNAME"
  export NEO4J_PASSWORD="$OC_NEO4J_PASSWORD"
  export NEO4J_DATABASE="$OC_NEO4J_DATABASE"

  # For google-docs MCP
  export GOOGLE_DOCS_MCP_CLIENT_ID="$OC_GOOGLE_DOCS_MCP_CLIENT_ID"
  export GOOGLE_DOCS_MCP_CLIENT_SECRET="$OC_GOOGLE_DOCS_MCP_CLIENT_SECRET"

  # For grafana MCP
  export GRAFANA_URL="$OC_GRAFANA_URL"
  export GRAFANA_SERVICE_ACCOUNT_TOKEN="$OC_GRAFANA_SERVICE_ACCOUNT_TOKEN"

  # For teamcity MCP
  export TC_AUTH_TOKEN="$OC_TC_AUTH_TOKEN"

  opencode "$@"
}

alias ak='goak'
alias ocserve='oc serve --port=$OC_PORT --log-level=INFO'
