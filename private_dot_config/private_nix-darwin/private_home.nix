{ pkgs, lib, ... }:

{
  programs = {
    home-manager.enable = true;

    firefox = {
      enable = true;

      nativeMessagingHosts = with pkgs; [
        browserpass
      ];

      profiles.personal = {
        id = 0;
        name = "Personal";
        search = {
          force = true;
          default = "google";
          privateDefault = "google";
        };
        settings = {
          "browser.bookmarks.addedImportButton" = false;
          "browser.bookmarks.showMobileBookmarks" = false;
          "browser.newtab.extensionControlled" = true;
          "browser.search.countryCode" = "GB";
          "browser.search.geoSpecificDefaults" = false;
          "browser.search.geoip.url" = "";
          "browser.search.isUS" = false;
          "browser.search.region" = "GB";
          "browser.search.suggest.enabled" = false;
          "browser.startup.homepage" = "about:blank";
          "browser.startup.homepage_override.extensionControlled" = true;
          "browser.toolbars.bookmarks.visibility" = "never";

          "font.default.x-western" = "sans-serif";
          "font.name.monospace.x-western" = "OperatorMonoSSm Nerd Font";
          "font.name.sans-serif.x-western" = "Source Sans 3";
          "font.name.serif.x-western" = "Source Sans 3";
          "font.size.monospace.x-western" = 14;
          "font.size.variable.x-western" = 18;

          "distribution.searchplugins.defaultLocale" = "en-GB";
          "general.useragent.locale" = "en-GB";
          "geo.enabled" = false;
          "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        };
      };
    };
  };

  home.activation = {
    firefox-user-chrome = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
      run ln -sf \
        "$HOME/personal/minimal-functional-fox" \
        "$HOME/Library/Application Support/Firefox/Profiles/personal/chrome";
    '';
  };

  home.stateVersion = "25.11";
}
