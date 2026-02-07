# vim:filetype=zsh
zstyle -d ':completion:*' format
zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
# shellcheck disable=SC2086,SC2296
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' menu no

FZF_TAB_GROUP_COLORS=(
    $'\033[32m' $'\033[33m' $'\033[36m' $'\033[37m' $'\033[31m' $'\033[35m'
)
# shellcheck disable=SC2086,SC2128
zstyle ':fzf-tab:*' group-colors $FZF_TAB_GROUP_COLORS

zstyle ':fzf-tab:*' prefix ''
zstyle ':fzf-tab:*' switch-group '[' ']'
zstyle ':fzf-tab:*' use-fzf-default-opts yes
