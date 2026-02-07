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
    less
    neovim
    zsh
  ];

  devel = with pkgs; [
    binaryen
    cppcheck
    git
    git-lfs
    jless
    jq
    llvm
    openssh
    openssl
    yq
  ];

  gpg = with pkgs; [
    gnupg # Provides gpg and gpg-agent
    gpgme
    libassuan
    pinentry_mac # Stable symlink at ~/.nix-profile/bin/pinentry-mac
  ];

  tools = with pkgs; [
    _1password-cli
    aria2
    axel
    curlie
    delta
    direnv
    eza
    fd
    fzf
    httpie
    keychain
    mise
    ncdu
    p7zip
    parallel
    qrencode
    ripgrep
    smug
    starship
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

  home.packages = base ++ devel ++ gpg ++ tools ++ gui;

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
