# 1. Install Determinate Nix

```shell
$ curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

# 2. Achieve machine ID & configure hostname:

```shell
$ machine_id=$(system_profiler SPHardwareDataType | awk -F': ' '/Serial Number/ { print $2 }')
$ hostname="macintosh-$machine_id"
$ echo "hostname: $hostname"
$ sudo scutil --set LocalHostName "$hostname"
```

# 3. Terraform `nix-darwin`

```shell
$ chezmoi init \
    github.com/ethan605 \
    --promptString machine_id="$machine_id" \
    --promptString personal_gpg_id=not_applicable

$ chezmoi apply ~/.config/nix-darwin
```

# 4. Nixify:

```shell
$ /nix/var/nix/profiles/default/bin/nix build ".#darwinConfigurations.$hostname.system"
$ sudo ./result/sw/bin/darwin-rebuild switch --flake .
```
