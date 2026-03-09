#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

__install-fzf() {
	rm -rf ~/.fzf

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

	~/.fzf/install \
		--no-key-bindings \
		--no-completion \
		--no-update-rc \
		--no-fish
}

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo apt upgrade -y &&
		sudo apt install -y \
			bat eza fd-find gawk git-delta kubecolor \
			kubectx neovim ripgrep vivid zoxide zsh &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/*

	sudo ln -sf /usr/bin/batcat /usr/bin/bat

	__install-fzf
	sh -c "$(curl -sS https://starship.rs/install.sh)" -- -y
}

__configure-zsh() {
	rm -rf ~/.zim

	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

  zsh -ic 'zimfw build && zimfw compile'
}

__configure-chezmoi() {
	rm -rf ~/.local/share/chezmoi

	sh -c "$(curl -fsLS https://chezmoi.io/getlb)" -- -b ~/.local/bin

	chezmoi init \
		--promptString machine_id=devpod \
		--promptString personal_gpg_id=not_applicable \
		--promptString work_gpg_id=not_applicable \
		--apply https://github.com/ethan605/dotfiles \
		--force
}

__install-system-packages
__install-fzf
__configure-zsh
__configure-chezmoi
