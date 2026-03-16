#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo apt upgrade -y &&
		sudo apt install --no-install-recommends -y \
			libyaml-dev python3-venv zsh &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/*

	curl -fsSL https://mise.run | sh

	mise use -g \
		awscli@latest \
		bat@latest \
		bottom@latest \
		chezmoi@latest \
		delta@latest \
		direnv@latest \
		eza@latest \
		fd@latest \
		fzf@latest \
		gcloud@latest \
		kubecolor@latest \
		kubectx@latest \
		kubens@latest \
		lua@latest \
		neovim@latest \
		ripgrep@latest \
		ruby@latest \
		rust@latest \
		starship@latest \
		tree-sitter@latest \
		uv@latest \
		vivid@latest \
		zoxide@latest

	eval "$(mise activate bash)"
}

__configure-bash() {
	rm -rf ~/.local/share/fzf-tab-completion
	git clone https://github.com/lincheney/fzf-tab-completion ~/.local/share/fzf-tab-completion

	mkdir -p ~/dotfiles
	rm -rf ~/dotfiles/.bashrc

	cat <<EOF >~/dotfiles/.bashrc
# shellcheck disable=SC2148
# === Environments ===
export BAT_THEME=base16
export EDITOR=nvim
export MANPAGER='nvim +Man!'

export FZF_DEFAULT_OPTS='
  --ansi
  --bind=ctrl-y:preview-up,ctrl-e:preview-down,ctrl-u:preview-page-up,ctrl-d:preview-page-down
  --color=fg+:7,bg+:0,hl:5,hl+:5
  --color=gutter:0,header:4,marker:2,pointer:5,prompt:2,spinner:3
  --cycle
  --marker="›"
  --pointer="›"
  --prompt="❯ "
  --reverse
  --no-height
'
export FZF_CTRL_R_OPTS='
  --preview="echo {2..} | bat --color=always --language=zsh --number --plain"
  --bind="ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort"
  --header="Press CTRL-Y to copy command into clipboard"
'

export PATH="\$HOME/.local/bin/:\$PATH"

# === Plugins ===
eval "\$(mise activate bash)"
eval "\$(direnv hook bash)"
eval "\$(fzf --bash)"
eval "\$(zoxide init bash)"

if [[ -f \$HOME/.local/share/fzf-tab-completion/bash/fzf-bash-completion.sh ]]; then
	# shellcheck disable=SC1091
	source "\$HOME/.local/share/fzf-tab-completion/bash/fzf-bash-completion.sh"
	bind -x '"\\t": fzf_bash_completion'
fi

# === Utils & aliases ===
__system-upgrade() {
  # shellcheck disable=SC2033
	cat "\$HOME/.config/devbox/\$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update &&
		sudo apt upgrade -y &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/* &&
		mise plugins update &&
		mise upgrade --bump &&
		chezmoi apply --force &&
		nvim --headless \\
			-c 'Lazy! sync' \\
			-c MasonUpdate \\
			-c MasonLockRestore \\
			-c qa
}

alias c=chezmoi
alias k=kubecolor
alias l1='ls --oneline'
alias l='ls --long --icons=always --header'
alias lk='l --total-size --sort=size --reverse'
alias lr='l --tree --level=2'
alias ls='eza --group-directories-first --color=always --git --all'
alias rm='rm -i'
alias v=nvim
alias vi=nvim
alias vim=nvim
alias vserve='nvim --headless --listen 127.0.0.1:45678'
alias where=which
EOF
}

__configure-zsh() {
	rm -rf ~/.zim

	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

	zsh -ic 'zimfw build && zimfw compile'
}

__configure-chezmoi() {
	rm -rf ~/.local/share/chezmoi

	chezmoi init \
		--promptString machine_id=devpod \
		--promptString personal_gpg_id=not_applicable \
		--apply https://github.com/ethan605/dotfiles \
		--force

	git config --global user.email "$WORK_EMAIL" &&
		git config --global core.excludesfile ~/.gitignore_global
}

__configure-nvim() {
	nvim --headless \
		-c 'Lazy! sync' \
		-c MasonUpdate \
		-c MasonLockRestore \
		-c qa
}

__install-system-packages &&
	__configure-bash &&
	__configure-zsh &&
	__configure-chezmoi &&
	__configure-nvim
