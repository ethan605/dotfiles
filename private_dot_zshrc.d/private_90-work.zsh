# vim:filetype=zsh
export WORK_DIR="$HOME/work"
export OC_PORT=45678

if [[ -f "$WORK_DIR/.zshrc" ]]; then
  # shellcheck disable=SC1091
  source "$WORK_DIR/.zshrc"
fi

alias wpass='PASSWORD_STORE_DIR="$WORK_DIR/.password-store" pass'

alias psql-local='psql $(wpass postgres/uri-local)'
alias psql-dev='psql $(wpass postgres/uri-dev)'
alias psql-stg='psql $(wpass postgres/uri-stg)'
alias psql-prd-eu-ro='psql $(wpass postgres/uri-prd-eu-ro)'
alias psql-prd-eu-rw!='psql $(wpass postgres/uri-prd-eu-rw)'
alias psql-prd-us-ro='psql $(wpass postgres/uri-prd-us-ro)'
alias psql-prd-us-rw!='psql $(wpass postgres/uri-prd-us-rw)'

__wpass-insert() {
  local pass_name=${1}
  wpass insert --force --multiline "$pass_name" >/dev/null

  echo "Loaded $pass_name to wpass"
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
  export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

  # For Gemini
  export GOOGLE_VERTEX_PROJECT=$(gcloud config get project)
  export GOOGLE_VERTEX_LOCATION=global
  export VERTEX_LOCATION=global

  # For postgresql MCP
  # export POSTGRES_CONNECTION_STRING="postgres://postgres:postgres@localhost:5432/postgres"

  # For google-docs MCP
  export GOOGLE_DOCS_MCP_CLIENT_ID=$(wpass api-keys/google-docs-mcp | rg 'client_id:' | awk '{ print $2 }')
  export GOOGLE_DOCS_MCP_CLIENT_SECRET=$(wpass api-keys/google-docs-mcp | head -1)

  # For grafana MCP
  export GRAFANA_URL=https://grafana-deviam.neo4j-dev.io/
  export GRAFANA_SERVICE_ACCOUNT_TOKEN=$(wpass api-keys/grafana-deviam)

  # For teamcity MCP
  export TC_AUTH_TOKEN=$(wpass api-keys/teamcity-access-token)

  opencode "$@"
}

dbee-clickhouse() {
  export SQL_TARGET=clickhouse

  export DBEE_CONNECTIONS='[
    { "type": "clickhouse", "name": "5-clickhouse-local", "url": "'$(wpass clickhouse/uri-local)'" },
    { "type": "clickhouse", "name": "4-clickhouse-dev", "url": "'$(wpass clickhouse/uri-dev)'?secure=true" },
    { "type": "clickhouse", "name": "3-clickhouse-stg", "url": "'$(wpass clickhouse/uri-stg)'?secure=true" },
    { "type": "clickhouse", "name": "2-clickhouse-prd-us-ro", "url": "'$(wpass clickhouse/uri-prd-us-ro)'?secure=true" },
    { "type": "clickhouse", "name": "1-clickhouse-prd-eu-ro", "url": "'$(wpass clickhouse/uri-prd-eu-ro)'?secure=true" }
  ]'

  nvim +Dbee
}

dbee-postgres() {
  export SQL_TARGET=postgres

  export DBEE_CONNECTIONS='[
    { "type": "postgres", "name": "5-postgres-local", "url": "'$(wpass postgres/uri-local)'?sslmode=disable" },
    { "type": "postgres", "name": "4-postgres-dev", "url": "'$(wpass postgres/uri-dev)'?sslmode=require" },
    { "type": "postgres", "name": "3-postgres-stg", "url": "'$(wpass postgres/uri-stg)'?sslmode=require" },
    { "type": "postgres", "name": "2-postgres-prd-us-ro", "url": "'$(wpass postgres/uri-prd-us-ro)'?sslmode=require" },
    { "type": "postgres", "name": "1-postgres-prd-eu-ro", "url": "'$(wpass postgres/uri-prd-eu-ro)'?sslmode=require" }
  ]'

  nvim +Dbee
}

devbox() {
  # infocmp -x xterm-ghostty | ssh neo4j-cloud.devpod -- tic -x -
  LANG=C.UTF-8
  LC_ALL=C LC_COLLATE=C.UTF-8 LC_CTYPE=C.UTF-8 LC_MESSAGES=C.UTF-8
  LC_MONETARY=C.UTF-8 LC_NUMERIC=C.UTF-8 LC_TIME=C.UTF-8

  local for_oc=false

  while (("$#")); do
    case "$1" in
    --for-oc)
      for_oc=true
      shift
      ;;
    *)
      shift
      ;;
    esac
  done

  if [[ "$for_oc" == "true" ]]; then
    if lsof -Pi ":$OC_PORT" -sTCP:LISTEN -t >/dev/null; then
      echo "Port $OC_PORT is in use"
      return 1
    fi

    if [[ -z "$NEO4J_URI" ]]; then
      source "$HOME/work/queries/deviam-neostore/.envrc"
    fi

    local oc_envs="
OC_PORT=$OC_PORT \
OC_GOOGLE_DOCS_MCP_CLIENT_ID=$(wpass api-keys/google-docs-mcp | rg 'client_id:' | awk '{ print $2 }') \
OC_GOOGLE_DOCS_MCP_CLIENT_SECRET=$(wpass api-keys/google-docs-mcp | head -1) \
OC_GRAFANA_URL=https://grafana-deviam.neo4j-dev.io/ \
OC_GRAFANA_SERVICE_ACCOUNT_TOKEN=$(wpass api-keys/grafana-deviam) \
OC_TC_AUTH_TOKEN=$(wpass api-keys/teamcity-access-token) \
OC_NEO4J_URI=$NEO4J_URI \
OC_NEO4J_USERNAME=$NEO4J_USERNAME \
OC_NEO4J_PASSWORD=$NEO4J_PASSWORD \
OC_NEO4J_DATABASE=$NEO4J_DATABASE
"

    ssh neo4j-cloud.devpod \
      -o "SetEnv $oc_envs" \
      -L "$OC_PORT::$OC_PORT"
  else
    ssh neo4j-cloud.devpod
  fi
}

alias ocattach="opencode attach http://127.0.0.1:$OC_PORT"
alias ocbox='devbox --for-oc'
