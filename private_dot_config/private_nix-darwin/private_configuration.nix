{
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
    extraSpecialArgs = { inherit home-dir; };
    useGlobalPkgs = true;
    useUserPackages = true;
    users.${username} = ./home.nix;
    backupFileExtension = "bak.home-manager";
  };
}
