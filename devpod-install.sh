#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo apt upgrade -y &&
		sudo apt install --no-install-recommends -y \
			libyaml-dev zsh &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/*

	curl -fsSL https://mise.run | sh

	mise use -g \
		awscli@latest \
		bat@latest \
		chezmoi@latest \
		delta@latest \
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
}

__configure-nvim() {
	nvim --headless \
		-c 'Lazy! sync' \
		-c MasonUpdate \
		-c MasonLockRestore \
		-c qa
}

__configure-dotfiles() {
	rm -rf ~/dotfiles/*
	mkdir -p ~/dotfiles

	cat <<EOF >~/dotfiles/.bashrc
PATH="$HOME/.local/bin:$PATH"
eval "$(mise activate bash)"

__system-upgrade() {
  cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update &&
    sudo apt upgrade -y &&
    sudo apt autoremove -y &&
    sudo apt clean -y &&
    sudo rm -rf /var/lib/apt/lists/* &&
    mise plugins update &&
    mise upgrade --bump
}
EOF
}

__install-system-packages &&
	__configure-zsh &&
	__configure-chezmoi &&
	__configure-nvim &&
	__configure-dotfiles
