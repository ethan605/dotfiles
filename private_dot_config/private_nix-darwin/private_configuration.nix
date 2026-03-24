{ pkgs, username, home-dir, ... }:

{
  imports = [
    ./modules/packages
    ./modules/services.nix
    ./modules/system.nix
  ];

  determinateNix.enable = true;
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

  nixpkgs.overlays = [
    (final: prev: {
      direnv = prev.direnv.overrideAttrs {
        buildPhase = ''
          CGO_ENABLED=1 make BASH_PATH=$BASH_PATH
        '';
      };
    })
  ];

  nix-homebrew = {
    enable = true;
    user = username;
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = import ./home.nix { inherit pkgs home-dir; };
    backupFileExtension = "bak.home-manager";
  };
}
