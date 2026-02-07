{ pkgs, ... }:

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
  home.stateVersion = "25.11";

  home.packages = base ++ devel ++ docs ++ gpg ++ tools ++ gui;

  # Password store with extensions (properly wrapped)
  programs.password-store = {
    enable = true;
    package = pkgs.pass.withExtensions (exts: [
      exts.pass-otp
      exts.pass-update
    ]);
  };

  # Browserpass (native messaging host for browser extension)
  programs.browserpass.enable = true;

  # Let home-manager manage itself
  programs.home-manager.enable = true;
}
