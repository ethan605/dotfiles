# vim:filetype=zsh
export WORK_DIR="$HOME/work"

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
  local for_oc=false oc_port=45678

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

  LANG=C.UTF-8 LC_ALL=C.UTF-8 LC_CTYPE=C.UTF-8 LC_COLLATE=C.UTF-8
  TERM=xterm-256color

  if [[ "$for_oc" == "true" ]]; then
    if lsof -Pi ":$oc_port" -sTCP:LISTEN -t >/dev/null; then
      echo "Port $oc_port is in use"
      return 1
    fi

    ssh -o "SetEnv \
      OC_PORT=$oc_port \
      OC_GOOGLE_DOCS_MCP_CLIENT_ID=$(wpass api-keys/google-docs-mcp | rg 'client_id:' | awk '{ print $2 }') \
      OC_GOOGLE_DOCS_MCP_CLIENT_SECRET=$(wpass api-keys/google-docs-mcp | head -1) \
      OC_GRAFANA_URL=https://grafana-deviam.neo4j-dev.io/ \
      OC_GRAFANA_SERVICE_ACCOUNT_TOKEN=$(wpass api-keys/grafana-deviam) \
      " \
      -L "$oc_port::$oc_port" \
      neo4j-cloud.devpod
  else
    ssh neo4j-cloud.devpod
  fi
}

alias ocattach='opencode attach http://127.0.0.1:45678'
