#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

sudo apt upgrade &&
	sudo -S apt install -y \
		bat eza fd-find gawk kubecolor \
		kubectx neovim ripgrep vivid zoxide &&
	sudo apt autoremove &&
	sudo apt clean &&
	sudo rm -rf /var/lib/apt/lists/*

rm -rf ~/.local/share/chezmoi

sh -c "$(curl -fsLS https://chezmoi.io/getlb)" -- -b ~/.local/bin

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

# === ble.sh ===
rm -rf ~/ble.sh

git clone --recursive --depth 1 --shallow-submodules \
	https://github.com/akinomyoga/ble.sh.git \
	~/ble.sh

make -C ~/ble.sh

# === fzf ===

rm -rf ~/.fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

~/.fzf/install \
	--key-bindings \
	--no-completion \
	--no-update-rc \
	--no-zsh \
	--no-fish
