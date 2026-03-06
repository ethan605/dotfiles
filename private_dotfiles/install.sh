#!/usr/bin/env bash
set -euo pipefail

sh -c "$(curl -fsLS https://chezmoi.io/getlb)" -- -b "$HOME/.local/bin"
export PATH="$HOME/.local/bin:$PATH"

# Remove everything else
rm -rf ~/dotfiles/.*
rm -rf ~/dotfiles/LICENSE
rm -rf ~/dotfiles/README.md
rm -rf ~/dotfiles/misc
rm -rf ~/dotfiles/private_Library
rm -rf ~/dotfiles/private_dot_*

chezmoi init \
	--promptString machine_id=devpod \
	--promptString work_email=thanh.nguyen@neo4j.com \
	--apply https://github.com/ethan605/dotfiles \
	--force

# Remove the final bits
rm -rf ~/dotfiles/private_dotfiles

# shellcheck disable=SC2024
sudo -S apt install -y \
	bat eza neovim vivid zoxide \
	<"$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw"
