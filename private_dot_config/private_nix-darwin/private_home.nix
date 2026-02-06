{ pkgs, ... }:

let
  base = with pkgs; [
    bash
    coreutils
    diffutils
    findutils
    gnugrep
    gnused
    gnutar
    wget
    zsh
  ];

  devel = with pkgs; [
    binaryen
    cppcheck
    git
    llvm
    neovim
    openssh
  ];

  gpg = with pkgs; [
    gnupg # Provides gpg and gpg-agent
    gpgme
    libassuan
    pinentry_mac # Stable symlink at ~/.nix-profile/bin/pinentry-mac
  ];

  tools = with pkgs; [
    aria2
    axel
    httpie
    keychain
    ncdu
    p7zip
    parallel
    qrencode
    smug
    vifm
    watch
    zbar
  ];

  gui = with pkgs; [
    aerospace
    alacritty
    appcleaner
    firefox
    flameshot
    karabiner-elements
    keybase
    sketchybar
    telegram-desktop
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
