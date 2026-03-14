{ pkgs, ... }:

with pkgs;
let
  base = [
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

  docs = [
    bat
    bat-extras.core
    less
    man
    man-db
    tlrc
    vivid
  ];

  cloud-native = [
    argo-rollouts
    devpod
    kubecolor
    kubectl
    kubectx
    orbstack
  ];

  svc = [
    delta
    git
    git-lfs
  ];

  devel = [
    cppcheck
    ffmpeg
    httpie
    hyperfine
    imagemagick
    jq
    nil # nil depends on nix, so installing here instead of Mason
    parallel
    qrencode
    viddy
    watch
    yq
    zbar
  ] ++ docs ++ cloud-native ++ svc;

  archives = [
    lzip
    p7zip
    xz
    zip
  ];

  gpg = [
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

  media = [
    blueutil
    catt
    iina
    mpc
    mpd
    switchaudio-osx
  ];

  cli = archives ++ gpg ++ media;

  tui = [
    aria2
    bottom
    duf
    gdu
    jless
    neo
    pipes-rs
    smug
    tmux
    vifm
  ];

  gui = [
    aerospace
    alacritty
    appcleaner
    flameshot
  ];

  self-host-fonts = pkgs.callPackage ./self-host-fonts.nix { inherit pkgs; };
in
{
  fonts.packages = [
    pkgs.source-code-pro
    self-host-fonts
  ];

  programs.zsh.enable = true;

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
      "ghostty"
      "grammarly-desktop"
      "homerow"
      "karabiner-elements" # can't use services.karabiner-elements
      "linear-linear"
      "logi-options+"
      "telegram"
      "whatsapp"

      # "logitune"
      # "megasync"
    ];
  };

  environment = {
    enableAllTerminfo = true;
    shells = [ pkgs.zsh ];
    systemPackages = base ++ devel ++ cli ++ tui ++ gui;
  };
}
