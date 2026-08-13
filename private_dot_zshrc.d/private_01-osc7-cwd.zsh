# vim:filetype=zsh
__osc7-cwd() {
  setopt localoptions extendedglob
  input=( ${(s::)PWD} )
  uri=${(j::)input/(#b)([^A-Za-z0-9_.\!~*\'\(\)-\/])/%${(l:2::0:)$(([##16]#match))}}
  print -n "\e]7;file://${HOSTNAME}${uri}\e\\"
}

autoload -Uz add-zsh-hook
add-zsh-hook -Uz chpwd __osc7-cwd
