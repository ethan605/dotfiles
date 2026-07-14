{ inputs, system, ... }:

let
  pkgs-26-05 = import inputs.nixpkgs-26-05 { inherit system; };
in
{
  nixpkgs.overlays = [
    (_final: prev: {
      # Overriden packages (due to instabilities, bugs, etc.)
      blueutil = pkgs-26-05.blueutil;
      sketchybar = pkgs-26-05.sketchybar;
      unar = pkgs-26-05.unar;
      # zsh = pkgs-26-05.zsh;

      # Self-host packages
      minimal-functional-fox = prev.callPackage ./modules/packages/minimal-functional-fox.nix { };
      self-host-fonts = prev.callPackage ./modules/packages/self-host-fonts.nix { };
    })
  ];
}
