{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    alacritty
  ];

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
