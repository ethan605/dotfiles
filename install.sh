#!/usr/bin/env bash

curl -fsLS https://get.chezmoi.io | sh -
chezmoi init https://github.com/ethan605/dotfiles
