{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    browserpass
  ];

  programs = {
    browserpass.enable = true;
    home-manager.enable = true;
  };
}
