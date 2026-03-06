#!/usr/bin/env bash
set -euo pipefail

if ! command -v chezmoi &>/dev/null; then
	curl -fsLS https://chezmoi.io/getlb | sh -
	export PATH="$HOME/.local/bin:$PATH"
fi

rm -rf ~/dotfiles/.*
rm -rf ~/dotfiles/LICENSE
rm -rf ~/dotfiles/README
rm -rf ~/dotfiles/misc
rm -rf ~/dotfiles/private_Library
rm -rf ~/dotfiles/private_dot_*

chezmoi init \
	--promptString machine_id=devpod \
	--promptString work_email=thanh.nguyen@neo4j.com \
	--apply https://github.com/ethan605/dotfiles \
  --force

# shellcheck disable=SC2024
sudo -S apt install -y \
	bat eza neovim vivid zoxide \
	<"$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw"
