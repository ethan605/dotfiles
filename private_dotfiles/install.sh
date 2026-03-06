#!/usr/bin/env bash
set -euo pipefail

if ! command -v chezmoi &>/dev/null; then
	curl -fsLS https://chezmoi.io/getlb | sh -
	export PATH="$HOME/.local/bin:$PATH"
fi

rm -rf "$HOME/dotfiles/.*"
rm -rf "$HOME/dotfiles/LICENSE"
rm -rf "$HOME/dotfiles/README"
rm -rf "$HOME/dotfiles/misc"
rm -rf "$HOME/dotfiles/private_Library"
rm -rf "$HOME/dotfiles/private_dot_*"

chezmoi init \
	--promptString machine_id=devpod \
	--promptString work_email=thanh.nguyen@neo4j.com \
	--apply https://github.com/ethan605/dotfiles \
  --force

# shellcheck disable=SC2024
sudo -S apt install -y \
	bat eza neovim vivid zoxide \
	<"$HOME/.config/devbox/$DEVPOD_WORKSPACE_UID/ubuntu_pw"
