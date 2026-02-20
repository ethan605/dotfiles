#!/usr/bin/env bash

sudo nix-collect-garbage --delete-older-than 1d && nix-collect-garbage --delete-older-than 1d
