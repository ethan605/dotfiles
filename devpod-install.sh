#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo add-apt-repository main -y &&
		sudo add-apt-repository universe -y &&
		sudo add-apt-repository restricted -y &&
		sudo add-apt-repository multiverse -y &&
		sudo apt-get upgrade -y &&
		sudo apt-get install --no-install-recommends -y \
			libyaml-dev python3-venv zsh &&
		sudo apt-get autoremove -y &&
		sudo apt-get clean -y &&
		sudo rm -rf /var/lib/apt/lists/*

	curl -fsSL https://mise.run | sh

	mise use -g \
		awscli@latest \
		azure@latest \
		bat@latest \
		bottom@latest \
		chezmoi@latest \
		delta@latest \
		direnv@latest \
		eza@latest \
		fd@latest \
		fzf@latest \
		gcloud@latest \
		gh@latest \
		go@latest \
		kubecolor@latest \
		kubectl@latest \
		kubectx@latest \
		kubens@latest \
		kustomize@latest \
		lua@latest \
		neovim@latest \
		node@latest \
		opencode@latest \
		python@3.10 \
		ripgrep@latest \
		rtk@latest \
		ruby@latest \
		rust@latest \
		starship@latest \
		tree-sitter@latest \
		usage@latest \
		uv@latest \
		vivid@latest \
		zoxide@latest

	eval "$(mise activate bash)"
}

__configure-bash() {
	rm -rf ~/.local/share/fzf-tab-completion
	git clone https://github.com/lincheney/fzf-tab-completion ~/.local/share/fzf-tab-completion
}

__configure-zsh() {
	rm -rf ~/.zim
	curl -fsSL https://raw.githubusercontent.com/zimfw/install/master/install.zsh | zsh
	zsh -ic 'zimfw build && zimfw compile'
}

__configure-chezmoi() {
	rm -rf ~/.local/share/chezmoi

	chezmoi init \
		github.com/ethan605 \
		--promptString machine_id=devpod \
		--promptString personal_gpg_id=not_applicable \
		--apply \
		--force

	mkdir -p ~/dotfiles
	ln -s ~/.config/devpod/.bashrc ~/dotfiles/.bashrc
	ln -s ~/.config/devpod/.gitconfig ~/.gitconfig
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
