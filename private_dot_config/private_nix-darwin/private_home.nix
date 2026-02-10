{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;
      nativeMessagingHosts = with pkgs; [
        browserpass
      ];
    };
  };
}
