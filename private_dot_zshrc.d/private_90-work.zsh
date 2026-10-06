# vim:filetype=zsh
export WORK_DIR="$HOME/work"

if [[ -f "$WORK_DIR/.zshrc" ]]; then
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

  ssh neo4j-cloud.devpod

#   local for_oc=false
#
#   while (("$#")); do
#     case "$1" in
#     --for-oc)
#       for_oc=true
#       shift
#       ;;
#     *)
#       shift
#       ;;
#     esac
#   done
#
#   if [[ "$for_oc" == "true" ]]; then
#     __random-passwd | wpass insert --echo --force oc-server-pw
#
#     if lsof -Pi ":$OC_PORT" -sTCP:LISTEN -t >/dev/null; then
#       echo "Port $OC_PORT is in use"
#       return 1
#     fi
#
#     if [[ -z "$NEO4J_URI" ]]; then
#       source "$HOME/work/queries/deviam-neostore/.envrc"
#     fi
#
#     local oc_envs="
# OC_PORT=$OC_PORT \
# OC_SERVER_PW=$(wpass oc-server-pw) \
# OC_BIFROST_VIRTUAL_KEY=$(wpass bifrost/vk-opencode-work) \
# OC_MCPHUB_BEARER_TOKEN=$(wpass mcphub/bearer-token)
# "
#
#     ssh neo4j-cloud.devpod \
#       -o "SetEnv $oc_envs" \
#       -L "$OC_PORT::$OC_PORT"
#   else
#     ssh neo4j-cloud.devpod
#   fi
}

alias ocs="opencode session list | fzf --header-lines=2 --sync | awk '{ print \$1 }' | tr -d '\n'"

# export OC_PORT=45678
# alias ocbox='devbox --for-oc'
# alias ocattach='opencode attach --password=$(wpass oc-server-pw) http://127.0.0.1:$OC_PORT'
