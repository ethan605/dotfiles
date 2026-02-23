{ pkgs, ... }:

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
    switchaudio-osx
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
in
{
  fonts.packages = [
    pkgs.lilex
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
      "homerow"
      "karabiner-elements" # can't use services.karabiner-elements
      "logi-options+"
      "telegram"
      "whatsapp"
    ];
  };

  environment = {
    enableAllTerminfo = true;
    shells = [ pkgs.zsh ];
    systemPackages = base ++ devel ++ cli ++ tui ++ gui;
  };
}
