{ pkgs, username, hostname, ... }:

let
  base = with pkgs; [
    bash
    chezmoi
    coreutils
    diffutils
    findutils
    gnugrep
    gnused
    gnutar
    mise
    neovim
    zoxide
    zsh
  ];

  docs = with pkgs; [
    bat
    bat-extras.core
    less
    man
    man-db
    tlrc
    vivid
  ];

  cloud-native = with pkgs; [
    argo-rollouts
    kubecolor
    kubectl
    kubectx
    orbstack
  ];

  svc = with pkgs; [
    delta
    git
    git-lfs
  ];

  devel = with pkgs; [
    cppcheck
    ffmpeg
    openssh
    openssl
    uv

    # PostgreSQL and utils
    postgresql_15
    postgresql_15.pg_config
  ] ++ docs ++ cloud-native ++ svc;

  gpg = with pkgs; [
    gnupg # gpg and gpg-agent
    gpgme.dev
    libassuan
    pinentry_mac

    (
      # UNIX Password Store
      pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-update
      ])
    )
  ];

  cli = with pkgs; [
    _1password-cli
    axel
    direnv
    eza
    fd
    fzf
    httpie
    jq
    p7zip
    parallel
    qrencode
    ripgrep
    starship
    watch
    wget
    yq
    zbar
  ];

  tui = with pkgs; [
    aria2
    bottom
    duf
    gdu
    jless
    pipes-rs
    smug
    tmux
    vifm
  ];

  gui = with pkgs; [
    aerospace
    alacritty
    appcleaner
    flameshot
    ghostty-bin
    vlc-bin
  ];

  self-host-fonts = pkgs.callPackage ./self-host-fonts.nix { inherit pkgs; };
in
{
  networking.hostName = hostname;
  time.timeZone = "Europe/London";

  fonts.packages = [ self-host-fonts ];
  programs.zsh.enable = true;
  services.sketchybar.enable = true;

  # Homebrew for GUI apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    brews = [
      "libmagic" # for python-magic
    ];

    casks = [
      "contexts"
      "homerow"
      "karabiner-elements" # TODO: check https://github.com/nix-darwin/nix-darwin/pull/1679
      "logi-options+"
      "telegram"
      "vox"
      "whatsapp"
    ];
  };

  environment = {
    systemPackages = base ++ devel ++ gpg ++ cli ++ tui ++ gui;
    shells = [ pkgs.zsh ];
  };

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
        AppleFontSmoothing = 2;
        AppleShowAllExtensions = true;
        InitialKeyRepeat = 15;
        KeyRepeat = 2;
        NSAutomaticWindowAnimationsEnabled = false;
        NSScrollAnimationEnabled = false;
        NSWindowResizeTime = 0.0;
        _HIHideMenuBar = true;

        "com.apple.swipescrolldirection" = true; # natural scroll
      };
      controlcenter.BatteryShowPercentage = true;
      dock = {
        persistent-apps = [
          "/Applications/Nix Apps/Alacritty.app"
          { spacer = { small = true; }; }
          "/Applications/Google Chrome.app"
          "/Users/${username}/Applications/Home Manager Apps/Firefox.app"
          { spacer = { small = true; }; }
          "/Applications/Slack.app"
          "/Applications/Notion.app"
          "/Applications/Linear.app"
          { spacer = { small = true; }; }
          "/Applications/Telegram.app"
          "/Applications/Whatsapp.app"
        ];

        autohide = true;
        autohide-delay = 0.0;
        autohide-time-modifier = 0.0;
        dashboard-in-overlay = false;
        expose-animation-duration = 0.0;
        magnification = false;
        mineffect = "scale";
        minimize-to-application = true;
        mouse-over-hilite-stack = true;
        showhidden = true;
        show-recents = false;
      };
      finder = {
        AppleShowAllFiles = true;
        ShowPathbar = true;
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
        Clicking = true;
        DragLock = false;
        Dragging = true;
        TrackpadRightClick = true;
        TrackpadThreeFingerDrag = true;
        TrackpadThreeFingerTapGesture = 0;
      };
    };

    activationScripts.postActivation.text = ''
      chsh -s /run/current-system/sw/bin/zsh ${username};
    '';
  };

  # Touch ID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
