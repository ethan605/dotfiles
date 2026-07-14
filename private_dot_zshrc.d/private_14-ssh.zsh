# vim:filetype=zsh
unset SSH_AGENT_PID

if [[ -d "$HOME/.breakglass-gnupg" ]]; then
  export GNUPGHOME="$HOME/.breakglass-gnupg"
fi

# SSH_AUTH_SOCK is stable per GNUPGHOME; cache it to avoid a gpgconf fork each startup.
if [[ "${gnupg_SSH_AUTH_SOCK_by:-0}" -ne $$ ]]; then
  _sock_cache="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/ssh-auth-sock"
  if [[ -s $_sock_cache ]]; then
    SSH_AUTH_SOCK="$(<$_sock_cache)"
  else
    SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    [[ -d ${_sock_cache:h} ]] || mkdir -p "${_sock_cache:h}"
    print -r -- "$SSH_AUTH_SOCK" >| "$_sock_cache"
  fi
  export SSH_AUTH_SOCK
  unset _sock_cache
fi

export GPG_TTY=$TTY

# Defer `gpg-connect-agent updatestartuptty` to the first prompt (off the critical path).
autoload -Uz add-zsh-hook
_gpg_update_tty() {
  gpg-connect-agent updatestartuptty /bye >/dev/null 2>&1
  add-zsh-hook -d precmd _gpg_update_tty
  unfunction _gpg_update_tty
}
add-zsh-hook precmd _gpg_update_tty
