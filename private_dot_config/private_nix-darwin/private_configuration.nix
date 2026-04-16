{
  pkgs,
  username,
  home-dir,
  ...
}:

{
  imports = [
    ./modules/packages
    ./modules/services.nix
    ./modules/system.nix
  ];

  determinateNix.enable = true;
  nix.enable = false;
  nixpkgs.config.allowUnfree = true;

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
