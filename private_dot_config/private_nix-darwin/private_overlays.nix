{ inputs, system, ... }:

let
  pkgs-26-05 = import inputs.nixpkgs-26-05 { inherit system; };
in
{
  nixpkgs.overlays = [
    (_final: prev: {
      # Overriden packages (due to instabilities, bugs, etc.)
      unar = pkgs-26-05.unar;

      # Self-host packages
      minimal-functional-fox = prev.callPackage ./modules/packages/minimal-functional-fox.nix { };
      self-host-fonts = prev.callPackage ./modules/packages/self-host-fonts.nix { };
    })
  ];
}
