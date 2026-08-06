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

__random-passwd() {
  tr -dc 'A-Za-z0-9!#&()*+,-./:;<=>?@[\]^_`{|}~' </dev/urandom |
    head -c 32
}

__wpass-insert() {
  local pass_name=${1}
  wpass insert --force --multiline "$pass_name" >/dev/null

  echo "Loaded $pass_name to wpass"
}

oc() {
  # Stable features
  export OPENCODE_DISABLE_CLAUDE_CODE=1
  export OPENCODE_DISABLE_LSP_DOWNLOAD=1
  export OPENCODE_DISABLE_TERMINAL_TITLE=1
  export OPENCODE_ENABLE_EXA=1

  # Experimental features
  export OPENCODE_EXPERIMENTAL=1
  export OPENCODE_EXPERIMENTAL_BACKGROUND_SUBAGENTS=1
  export OPENCODE_EXPERIMENTAL_LSP_TOOL=1
  export OPENCODE_EXPERIMENTAL_PARALLEL=1
  export OPENCODE_EXPERIMENTAL_PLAN_MODE=1

  # For LSP servers
  export PATH="$HOME/.local/share/nvim/mason/bin:$PATH"

  # For google-docs MCP
  export GOOGLE_DOCS_MCP_CLIENT_ID=$(wpass api-keys/google-docs-mcp | rg 'client_id:' | awk '{ print $2 }')
  export GOOGLE_DOCS_MCP_CLIENT_SECRET=$(wpass api-keys/google-docs-mcp | head -1)

  # For grafana MCP
  export GRAFANA_URL=https://grafana-deviam.neo4j-dev.io/
  export GRAFANA_SERVICE_ACCOUNT_TOKEN=$(wpass api-keys/grafana-deviam)

  # For okta-integrator MCP
  export OKTA_ORG_URL=$(wpass api-keys/okta-integrator-mcp | rg 'org_url:' | awk '{ print $2 }')
  export OKTA_CLIENT_ID=$(wpass api-keys/okta-integrator-mcp | head -1)
  export OKTA_SCOPES="okta.users.read okta.users.manage okta.groups.read okta.groups.manage okta.apps.read okta.apps.manage okta.policies.read okta.policies.manage okta.deviceAssurance.read okta.deviceAssurance.manage okta.logs.read okta.brands.read okta.brands.manage okta.templates.read okta.templates.manage okta.domains.read okta.domains.manage okta.emailDomains.read okta.emailDomains.manage"

  # For postgresql MCP
  # export POSTGRES_CONNECTION_STRING="postgres://postgres:postgres@localhost:5432/postgres"

  # For Bifrost MCP Gateway
  export BIFROST_VIRTUAL_KEY=$(wpass bifrost/vk-opencode-host)

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
    __random-passwd | wpass insert --echo --force oc_server_pw

    if lsof -Pi ":$OC_PORT" -sTCP:LISTEN -t >/dev/null; then
      echo "Port $OC_PORT is in use"
      return 1
    fi

    if [[ -z "$NEO4J_URI" ]]; then
      source "$HOME/work/queries/deviam-neostore/.envrc"
    fi

    local oc_envs="
OC_PORT=$OC_PORT \
OC_SERVER_PW=$(wpass oc_server_pw) \
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

alias ocattach='opencode attach --password=$(wpass oc_server_pw) http://127.0.0.1:$OC_PORT'
alias ocbox='devbox --for-oc'
