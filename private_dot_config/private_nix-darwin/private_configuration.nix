{ pkgs, username, hostname, machineId, ... }:

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
    zsh
  ];

  devel = with pkgs; [
    binaryen
    cppcheck
    dotenvx
    ffmpeg
    git
    git-lfs
    jless
    jq
    llvm
    openssh
    openssl
    yq
  ];

  docs = with pkgs; [
    bat
    bat-extras.core
    less
    man
    man-db
  ];

  gpg = with pkgs; [
    gnupg # gpg and gpg-agent
    gpgme
    libassuan
    pinentry_mac

    # UNIX Password Store
    browserpass
    (
      pass.withExtensions (exts: [
        exts.pass-audit
        exts.pass-otp
        exts.pass-update
      ])
    )
  ];

  tools = with pkgs; [
    _1password-cli
    aria2
    axel
    delta
    direnv
    duf
    eza
    fd
    fzf
    httpie
    keychain
    ncdu
    p7zip
    parallel
    qrencode
    ripgrep
    smug
    starship
    tlrc
    tmux
    vifm
    watch
    wget
    zbar
    zoxide
  ];

  gui = with pkgs; [
    alacritty
  ];
in
{
  networking.hostName = "${hostname}-${machineId}";
  programs.zsh.enable = true;
  fonts.packages = [ ];

  # Homebrew for GUI apps
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      cleanup = "uninstall"; # Use "zap" after first successful run
      upgrade = true;
    };

    taps = [
      "nikitabobko/tap"
      "felixkratz/formulae"
    ];

    brews = [
      "felixkratz/formulae/sketchybar"
    ];

    casks = [
      "appcleaner"
      "contexts"
      "firefox"
      "flameshot"
      "ghostty"
      "homerow"
      "karabiner-elements"
      "keybase"
      "logi-options+"
      "nikitabobko/tap/aerospace"
      "nordvpn"
      "telegram"
      "vlc"
      "vox"
      "whatsapp"
    ];
  };

  environment = {
    systemPackages = base ++ devel ++ docs ++ gpg ++ tools ++ gui;

    shells = [
      pkgs.zsh
    ];
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
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  users.users.${username} = {
    name = username;
    home = "/Users/${username}";
    shell = pkgs.zsh;
  };
}
