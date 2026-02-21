{ pkgs, username, hostname, ... }:

let
  base = with pkgs; [
    axel
    bash
    chezmoi
    coreutils
    diffutils
    direnv
    eza
    fd
    findutils
    fzf
    gnugrep
    gnused
    gnutar
    mise
    neovim
    ripgrep
    starship
    wget
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
    httpie
    hyperfine
    jq
    parallel
    qrencode
    uv
    watch
    yq
    zbar

    # PostgreSQL and utils
    postgresql_15
    postgresql_15.pg_config
  ] ++ docs ++ cloud-native ++ svc;

  archives = with pkgs; [
    lzip
    p7zip
    xz
    zip
  ];

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

  media = with pkgs; [
    iina
    mpc
    mpd
  ];

  cli = with pkgs; [
    _1password-cli
  ] ++ archives ++ gpg ++ media;

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
    flameshot
    ghostty-bin
  ];

  self-host-fonts = pkgs.callPackage ./self-host-fonts.nix { inherit pkgs; };

  home-dir = "/Users/${username}";
  dock-spacer = { spacer = { small = true; }; };
in
{
  networking.hostName = hostname;
  time.timeZone = "Europe/London";

  fonts.packages = [ self-host-fonts ];
  programs.zsh.enable = true;
  services.sketchybar.enable = true;

  launchd.agents = {
    mpd = {
      serviceConfig = {
        ProgramArguments = [
          "${pkgs.mpd}/bin/mpd"
          "--no-daemon"
          "${home-dir}/.config/mpd/mpd.conf"
        ];
        KeepAlive = true;
        RunAtLoad = true;
      };
    };
  };

  # Homebrew for GUI apps
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      cleanup = "zap";
      upgrade = true;
    };

    casks = [
      "contexts"
      "homerow"
      "karabiner-elements" # can't use services.karabiner-elements
      "logi-options+"
      "telegram"
      "whatsapp"
    ];
  };

  environment = {
    systemPackages = base ++ devel ++ cli ++ tui ++ gui;
    shells = [ pkgs.zsh ];
  };

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
          dock-spacer
          "/Applications/Google Chrome.app"
          "${home-dir}/Applications/Home Manager Apps/Firefox.app"
          dock-spacer
          "/Applications/Slack.app"
          "/Applications/Notion.app"
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
      };
    };

    activationScripts.postActivation.text = ''
      chsh -s /run/current-system/sw/bin/zsh ${username};
      ln -sf ${pkgs.file}/lib/libmagic.1.dylib /opt/homebrew/lib/libmagic.dylib; # for python-magic in uv
    '';
  };

  # Touch ID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };
}
