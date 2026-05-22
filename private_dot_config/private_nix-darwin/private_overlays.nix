{
  inputs,
  system,
  ...
}:
let
  pkgs-25-11 = import inputs.nixpkgs-25-11 { inherit system; };
in
{
  nixpkgs.overlays = [
    (_final: prev: {
      # Overriden packages (due to instabilities, bugs, etc.)
      termite = pkgs-25-11.termite;
      zsh = pkgs-25-11.zsh;

      # Self-host packages
      minimal-functional-fox = prev.callPackage ./modules/packages/minimal-functional-fox.nix { };
      self-host-fonts = prev.callPackage ./modules/packages/self-host-fonts.nix { };
    })
  ];
}
