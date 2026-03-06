#!/usr/bin/env bash

curl -fsLS https://get.chezmoi.io | sh -
chezmoi init --apply https://github.com/ethan605/dotfiles

sudo apt install -y \
	bat eza neovim vivid zoxide
