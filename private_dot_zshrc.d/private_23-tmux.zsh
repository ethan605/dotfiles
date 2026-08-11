# vim:filetype=zsh
alias matrix='neo --async --bold=2 --defaultbg --fullwidth --screensaver --speed=16'
alias pipes='pipes-rs --fps=60 --kinds=light,curved,knobby --pipe-num=$(($(od -vAn -N1 -tu1 < /dev/urandom) % 10))'

greek-letters() {
  print -P "alpha: %F{red}α%f,beta: %F{red}β%f,gamma: %F{red}γ%f,delta: %F{red}δ%f,epsilon: %F{red}ε%f,theta: %F{red}θ%f,lambda: %F{red}λ%f,mu: %F{red}μ%f,pi: %F{red}π%f,sigma: %F{red}σ%f,phi: %F{red}φ%f,omega: %F{red}ω%f" \
    | tr ',' '\n' \
    | fzf --ansi \
    | awk '{ print $2 }'
}

mux() {
  local sessions workspace

  sessions=$(tmux list-sessions -F '#S' 2>/dev/null)

  if [[ -n "$1" ]]; then
    workspace="$1"
  elif [[ -n $sessions ]]; then
    workspace=$(echo "$sessions" | fzf)
  else
    workspace="$(greek-letters)"
  fi

  if [[ -n "$workspace" ]]; then
    tmux attach -t "$workspace" || tmux new -s "$workspace"
  fi
}
