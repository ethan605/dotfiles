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

      profiles.personal = {
        settings = {
          "browser.search.region" = "GB";
          "browser.search.isUS" = false;
          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "browser.bookmarks.showMobileBookmarks" = true;
        };
      };
    };
  };
}
