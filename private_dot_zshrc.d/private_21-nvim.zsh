# vim:filetype=zsh
# Remap system commands
alias nano=nvim
alias rm='rm -i'
alias vi=nvim
alias vim=nvim

# Utils
alias v=nvim
alias dbee='nvim +Dbee'
alias mason='nvim +Mason'
alias repl='nvim +Repl'
alias vremote='nvim --remote-ui --server localhost:45678'
alias vrestore!='nvim --headless "+Lazy! restore" +qa'
alias vserve='nvim --headless --listen 127.0.0.1:45678'
alias vsync='nvim --headless "+Lazy! sync" +MasonUpdate +qa'

vdiff() {
  if [[ $# == 0 ]]; then
    nvim +DiffviewOpen
  elif [[ $# == 1 ]]; then
    nvim "+DiffviewOpen $1..."
  else
    nvim "+DiffviewOpen $1...$2"
  fi
}
