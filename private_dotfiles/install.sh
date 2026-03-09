#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo apt upgrade -y &&
		sudo apt install -y \
			bat eza fd-find gawk kubecolor kubectx \
			neovim ripgrep vivid zoxide zsh &&
		sudo apt autoremove -y &&
		sudo apt clean -y &&
		sudo rm -rf /var/lib/apt/lists/*
}

__configure-fzf() {
	rm -rf ~/.fzf

	git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

	~/.fzf/install \
		--no-key-bindings \
		--no-completion \
		--no-update-rc \
		--no-fish
}

__configure-bash() {
	rm -rf \
		./ble.sh \
		~/.local/share/ble.sh

	git clone --recursive --depth 1 --shallow-submodules \
		https://github.com/akinomyoga/ble.sh.git

	make -C ble.sh install PREFIX=~/.local

	rm -rf ~/dotfiles/ble.sh

	rm -rf ~/.local/share/fzf-tab-completion

	git clone \
		https://github.com/lincheney/fzf-tab-completion \
		~/.local/share/fzf-tab-completion
}

__configure-zsh() {
	rm -rf ~/.zim

	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh

  sh -c "$(curl -sS https://starship.rs/install.sh)" -- -y
}

__configure-chezmoi() {
	# Remove unrelated files
	rm -rf \
		~/dotfiles/.* \
		~/dotfiles/LICENSE \
		~/dotfiles/README.md \
		~/dotfiles/misc \
		~/dotfiles/private_Library \
		~/dotfiles/private_dot_*

	rm -rf ~/.local/share/chezmoi

	sh -c "$(curl -fsLS https://chezmoi.io/getlb)" -- -b ~/.local/bin

	chezmoi init \
		--promptString machine_id=devpod \
		--promptString work_email=thanh.nguyen@neo4j.com \
		--apply https://github.com/ethan605/dotfiles \
		--force
}

__pre-clean-up
__install-system-packages
__configure-fzf

# Shell-specific configs
__configure-bash
__configure-zsh

__configure-chezmoi
