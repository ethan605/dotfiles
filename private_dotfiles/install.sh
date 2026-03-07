#!/usr/bin/env bash
set -euo pipefail

cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

sudo apt upgrade &&
	sudo -S apt install -y \
		bat eza fd-find fzf kubecolor kubectx \
		neovim ripgrep vivid zoxide &&
	sudo apt autoremove &&
	sudo apt clean &&
	sudo rm -rf /var/lib/apt/lists/*

if ! command -v chezmoi &>/dev/null; then
	sh -c "$(curl -fsLS https://chezmoi.io/getlb)" -- -b "$HOME/.local/bin"
	export PATH="$HOME/.local/bin:$PATH"
fi

# Remove unrelated files
rm -rf ~/dotfiles/.* \
	~/dotfiles/LICENSE \
	~/dotfiles/README.md \
	~/dotfiles/misc \
	~/dotfiles/private_Library \
	~/dotfiles/private_dot_*

chezmoi init \
	--promptString machine_id=devpod \
	--promptString work_email=thanh.nguyen@neo4j.com \
	--apply https://github.com/ethan605/dotfiles \
	--force

# Remove the final bits
rm -rf ~/dotfiles/private_dotfiles
