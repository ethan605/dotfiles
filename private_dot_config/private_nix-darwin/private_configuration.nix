{ pkgs, username, hostname, machineId, ... }:

{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  networking.hostName = "${hostname}-${machineId}";
  programs.zsh.enable = true;
  fonts.packages = [ ];

  # Homebrew (managed declaratively by nix-darwin)
  # Only for packages NOT available in nixpkgs
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall"; # Use "zap" after first successful run
      upgrade = true;
    };

    taps = [
      # "nikitabobko/tap"
      # "felixkratz/formulae"
    ];

    casks = [
      # "alacritty"
      "appcleaner"
      "contexts"
      # "felixkratz/formulae/sketchybar"
      "firefox"
      "flameshot"
      "ghostty"
      "homerow"
      "karabiner-elements"
      "keybase"
      "logi-options-plus"
      # "nikitabobko/tap/aerospace"
      "nordvpn"
      "telegram-desktop"
      "vlc"
      "vox"
      "whatsapp"
    ];
  };

  environment.shells = [
    pkgs.zsh
  ];

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };

  system = {
    stateVersion = 5;
    primaryUser = username;

    defaults = {
      NSGlobalDomain = {
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
      };
      dock = {
        autohide = true;
        show-recents = false;
      };
      finder = {
        AppleShowAllFiles = true;
        ShowPathbar = true;
      };
    };
  };

  # Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;
}
