#!/usr/bin/env bash
set -euo pipefail

export PATH="$HOME/.local/bin:$PATH"

# Remove unrelated files
rm -rf \
  ~/dotfiles/.* \
	~/dotfiles/LICENSE \
	~/dotfiles/README.md \
	~/dotfiles/misc \
	~/dotfiles/private_Library \
	~/dotfiles/private_dot_*

cat "$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw" | sudo -S apt update

sudo apt upgrade -y &&
	sudo apt install -y \
		bat eza fd-find gawk kubecolor \
		kubectx neovim ripgrep vivid zoxide &&
	sudo apt autoremove -y &&
	sudo apt clean -y &&
	sudo rm -rf /var/lib/apt/lists/*

# === chezmoi ===
rm -rf ~/.local/share/chezmoi

sh -c "$(curl -fsLS https://chezmoi.io/getlb)" -- -b ~/.local/bin

chezmoi init \
	--promptString machine_id=devpod \
	--promptString work_email=thanh.nguyen@neo4j.com \
	--apply https://github.com/ethan605/dotfiles \
	--force

# === ble.sh ===
rm -rf \
  ./ble.sh \
  ~/.local/share/ble.sh

git clone --recursive --depth 1 --shallow-submodules \
  https://github.com/akinomyoga/ble.sh.git

make -C ble.sh install PREFIX=~/.local

# === fzf ===
rm -rf ~/.fzf

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf

~/.fzf/install \
	--no-key-bindings \
	--no-completion \
	--no-update-rc \
	--no-zsh \
	--no-fish

rm -rf ~/.local/share/fzf-tab-completion

git clone \
  https://github.com/lincheney/fzf-tab-completion \
  ~/.local/share/fzf-tab-completion

# Clean-up
rm -rf \
  ~/dotfiles/private_dotfiles \
  ~/dotfiles/ble.sh

# shellcheck disable=SC1091
source "$HOME/dotfiles/.bashrc"
