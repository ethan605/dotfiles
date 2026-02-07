# vim:filetype=zsh
# Set editor default keymap to vi
bindkey -v

autoload -U edit-command-line
zle -N edit-command-line
bindkey -M vicmd 'vv' edit-command-line

# Word manipulation
bindkey '^w' backward-kill-word

# Vim-like bindings
bindkey '^h' backward-word        # left
bindkey '^l' forward-word         # right
bindkey '^k' up-line-or-search    # up
bindkey '^j' down-line-or-search  # down

# Ctrl-a and Ctrl-e to move to beginning/end of line
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line

# Shift+Tab as reverse completion
bindkey '^[[Z' reverse-menu-complete

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey "${terminfo[kcuu1]}" history-substring-search-up
  bindkey "${terminfo[kcud1]}" history-substring-search-down
fi

bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
