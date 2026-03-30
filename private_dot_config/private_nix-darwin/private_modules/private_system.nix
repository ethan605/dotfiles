{ pkgs, username, hostname, home-dir, ... }:

{
  networking.hostName = hostname;
  time.timeZone = "Europe/London";

  users.users.${username} = {
    name = username;
    home = home-dir;
    shell = pkgs.zsh;
  };

  system = {
    stateVersion = 5;
    primaryUser = username;

    defaults = {
      NSGlobalDomain = {
        "com.apple.swipescrolldirection" = true; # natural scroll
        AppleFontSmoothing = 2;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticWindowAnimationsEnabled = false;
        NSWindowResizeTime = 0.0;
        _HIHideMenuBar = true;
      };
      controlcenter.BatteryShowPercentage = true;
      dock = {
        persistent-apps =
          let
            dock-spacer = { spacer = { small = true; }; };
          in
          [
            # "/Applications/Nix Apps/Alacritty.app"
            "/Applications/Nix Apps/Ghostty.app"
            dock-spacer
            "/Applications/Google Chrome.app"
            "${home-dir}/Applications/Home Manager Apps/Firefox.app"
            dock-spacer
            "/Applications/Slack.app"
            "/Applications/Linear.app"
            dock-spacer
            "/Applications/Telegram.app"
            "/Applications/Whatsapp.app"
          ];

        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        dashboard-in-overlay = false;
        expose-animation-duration = 0.0;
        expose-group-apps = true;
        magnification = false;
        mineffect = "scale";
        minimize-to-application = true;
        mouse-over-hilite-stack = true;
        orientation = "left";
        showhidden = true;
        show-recents = false;
        tilesize = 40;
      };
      finder = {
        AppleShowAllExtensions = true;
        AppleShowAllFiles = true;
        FXDefaultSearchScope = "SCcf"; # current folder
        FXPreferredViewStyle = "clmv";
        ShowExternalHardDrivesOnDesktop = false;
        ShowMountedServersOnDesktop = false;
        ShowPathbar = true;
        ShowRemovableMediaOnDesktop = false;
        _FXEnableColumnAutoSizing = true;
        _FXSortFoldersFirst = true;
      };
      hitoolbox.AppleFnUsageType = "Do Nothing";
      menuExtraClock = {
        IsAnalog = false;
        Show24Hour = true;
        ShowDate = 1; # always
        ShowDayOfWeek = true;
        ShowSeconds = false;
      };
      spaces.spans-displays = true;
      trackpad = {
        ActuateDetents = true;
        Clicking = true;
        DragLock = false;
        Dragging = false;
        FirstClickThreshold = 0;
        ForceSuppressed = false;
        SecondClickThreshold = 0;
        TrackpadCornerSecondaryClick = 0;
        TrackpadFourFingerHorizSwipeGesture = 0;
        TrackpadFourFingerPinchGesture = 0;
        TrackpadFourFingerVertSwipeGesture = 2;
        TrackpadMomentumScroll = true;
        TrackpadPinch = true;
        TrackpadRightClick = true;
        TrackpadRotate = true;
        TrackpadThreeFingerDrag = true;
        TrackpadThreeFingerHorizSwipeGesture = 0;
        TrackpadThreeFingerTapGesture = 2;
        TrackpadThreeFingerVertSwipeGesture = 0;
        TrackpadTwoFingerDoubleTapGesture = true;
        TrackpadTwoFingerFromRightEdgeSwipeGesture = 3;
      };
    };

    activationScripts.postActivation.text = ''
      chsh -s /run/current-system/sw/bin/zsh ${username};

      # Manually update prefs that are not supported by nix-darwin
      sudo --user=${username} -- defaults write com.apple.AppleMultitouchTrackpad TrackpadFiveFingerPinchGesture -int 0;
      sudo --user=${username} -- defaults write com.apple.AppleMultitouchTrackpad TrackpadHorizScroll -bool true;
      sudo --user=${username} -- defaults write com.apple.AppleMultitouchTrackpad TrackpadScroll -bool true;
      sudo --user=${username} -- defaults write com.apple.AppleMultitouchTrackpad UserPreferences -bool true;

      # Uncheck "Save to Keychain" for pinentry-mac
      sudo --user=${username} -- defaults write org.gpgtools.common UseKeychain -bool false;
    '';
  };

  # Touch ID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
