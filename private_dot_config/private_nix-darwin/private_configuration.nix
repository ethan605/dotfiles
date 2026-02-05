{ pkgs, username, hostname, ... }:

{
  # Nix settings
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;

  # Set hostname
  networking.hostName = hostname;

  # Enable zsh (REQUIRED for nix-darwin to manage shell environment)
  programs.zsh.enable = true;

  # Fonts
  fonts.packages = [
  ];

  # Homebrew (managed declaratively by nix-darwin)
  # Only for packages NOT available in nixpkgs
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall"; # Use "zap" after first successful run
      upgrade = true;
    };

    casks = [
      "contexts"
      "homerow"
      "logi-options-plus"
      "nordvpn"
      "vox"
    ];
  };

  # macOS defaults
  system.defaults = {
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

  # Touch ID for sudo
  security.pam.enableSudoTouchIdAuth = true;

  # Define user
  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
  };

  system.stateVersion = 5;
}
