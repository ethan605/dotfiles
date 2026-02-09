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
    zsh
  ];

  devel = with pkgs; [
    argo-rollouts
    binaryen
    cppcheck
    ffmpeg
    git
    git-lfs
    jless
    jq
    kubecolor
    kubectl
    kubectx
    llvm
    openssh
    openssl
    orbstack
    postgresql_15
    uv
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
    gpgme.dev
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
    bottom
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
    aerospace
    alacritty
    appcleaner
    flameshot
    ghostty-bin
  ];
in
{
  networking.hostName = hostname;
  fonts.packages = [ ];

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
      "firefox"
      "homerow"
      "karabiner-elements"
      "logi-options+"
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

    activationScripts.postActivation.text = ''
      chsh -s /run/current-system/sw/bin/zsh ${username};
      ln -sf ${pkgs.browserpass}/lib/mozilla/native-messaging-hosts/com.github.browserpass.native.json '/Users/${username}/Library/Application Support/Mozilla/NativeMessagingHosts/com.github.browserpass.native.json';
    '';
  };

  # Touch ID for sudo
  security.pam.services.sudo_local = {
    touchIdAuth = true;
    reattach = true;
  };

  programs.zsh.enable = true;
  services.sketchybar.enable = true;
}
