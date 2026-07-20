{ pkgs, ... }:

let
  base = with pkgs; [
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
    devpod
    k9s
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

  devel =
    with pkgs;
    [
      cppcheck
      ffmpeg
      httpie
      hyperfine
      imagemagick
      jq
      nil # nil depends on nix, so installing here instead of Mason
      nixfmt
      nixfmt-tree
      parallel
      qrencode
      viddy
      watch
      yq
      zbar
    ]
    ++ docs
    ++ cloud-native
    ++ svc;

  archives = with pkgs; [
    lzip
    p7zip
    unar
    xz
    zip
  ];

  openpgp = with pkgs; [
    # gpg, gpg-agent, and gpg-related
    gnupg
    gpgme.dev
    libassuan
    pinentry_mac

    keybase
    openssh
    yubikey-manager

    (
      # UNIX Password Store
      pass.withExtensions (exts: [
        exts.pass-otp
        exts.pass-update
      ])
    )
  ];

  media = with pkgs; [
    blueutil
    iina
    mpc
    mpd
    switchaudio-osx
  ];

  cli = archives ++ openpgp ++ media;

  tui = with pkgs; [
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

  gui = with pkgs; [
    aerospace
    alacritty
    appcleaner
    ghostty-bin
    # thunderbird
    # zed-editor
  ];
in
{
  fonts.packages = with pkgs; [
    roboto-mono
    source-code-pro
    self-host-fonts
  ];

  programs.zsh = {
    enable = true;
    enableBashCompletion = false;
    enableGlobalCompInit = false;
    promptInit = "";
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
      "airflow"
      "contexts"
      "grammarly-desktop"
      "homerow"
      "karabiner-elements" # can't use services.karabiner-elements
      "keybase"
      "linear"
      "logi-options+"
      "macshot"
      "megasync"
      "telegram"
      "whatsapp"

      # "logitune"
    ];
  };

  environment = {
    enableAllTerminfo = true;
    shells = [ pkgs.zsh ];
    systemPackages = base ++ devel ++ cli ++ tui ++ gui;
    variables =
      let
        header_paths = builtins.concatStringsSep ":" [
          "${pkgs.libyaml.dev}/include"
        ];

        lib_paths = builtins.concatStringsSep ":" [
          "${pkgs.file}/lib"
          "${pkgs.libyaml}/lib"
          "${pkgs.pcre2.out}/lib"
        ];

        pkg_paths = builtins.concatStringsSep ":" [
          "${pkgs.libyaml.dev}/lib/pkgconfig"
        ];
      in
      {
        CPATH = header_paths;
        DYLD_FALLBACK_LIBRARY_PATH = lib_paths;
        # DYLD_LIBRARY_PATH = lib_paths; # SIP strips this for protected binaries
        LIBRARY_PATH = lib_paths;
        PKG_CONFIG_PATH = pkg_paths;
      };
  };
}
