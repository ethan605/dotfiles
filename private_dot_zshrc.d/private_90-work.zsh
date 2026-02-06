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

function __wpass-insert() {
  local pass_name=${1}
  wpass insert --force --multiline "$pass_name" >/dev/null

  echo "Loaded $pass_name to wpass"
}

function dbee-clickhouse() {
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

function dbee-postgres() {
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
