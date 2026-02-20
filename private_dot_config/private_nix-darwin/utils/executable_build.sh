#!/usr/bin/env bash

# To install:
# curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install

machine_id=$(system_profiler SPHardwareDataType | awk -F': ' '/Serial Number/ { print $2 }')
hostname="macintosh-$machine_id"
echo "hostname: $hostname"

sudo scutil --set LocalHostName "$hostname"

/nix/var/nix/profiles/default/bin/nix build ".#darwinConfigurations.$hostname.system"

sudo ./result/sw/bin/darwin-rebuild switch --flake .
