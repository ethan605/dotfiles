#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

__install-system-packages() {
	cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

	sudo add-apt-repository main -y &&
		sudo add-apt-repository universe -y &&
		sudo add-apt-repository restricted -y &&
		sudo add-apt-repository multiverse -y &&
		sudo add-apt-repository ppa:git-core/ppa -y

	sudo apt-key export 65F8F04B | sudo gpg --dearmour --yes -o /etc/apt/trusted.gpg.d/adoptium.gpg

	sudo apt-get upgrade -y &&
		sudo apt-get install --no-install-recommends -y \
			git libyaml-dev python3-venv vifm &&
		sudo apt-get autoremove -y &&
		sudo apt-get clean -y &&
		sudo rm -rf /var/lib/apt/lists/*

	curl -fsSL https://mise.run | sh

	mise use -g --pin lua@5.1

	mise use -g \
		bat@latest \
		chezmoi@latest \
		delta@latest \
		direnv@latest \
		eza@latest \
		fd@latest \
		fzf@latest \
		hyperfine@latest \
		kubecolor@latest \
		kubectx@latest \
		kubens@latest \
		neovim@latest \
		ripgrep@latest \
		starship@latest \
		tree-sitter@latest \
		vivid@latest \
		zoxide@latest

	eval "$(mise activate bash)"
}

__configure-bash() {
	rm -rf ~/.local/share/fzf-tab-completion
	git clone https://github.com/lincheney/fzf-tab-completion ~/.local/share/fzf-tab-completion
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
	ln -sf ~/.config/devpod/.bashrc ~/dotfiles/.bashrc
	ln -sf ~/.config/devpod/.gitconfig ~/.gitconfig
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
	__configure-chezmoi &&
	__configure-nvim
