{ pkgs, ... }:

let
  minimal-functional-fox = pkgs.callPackage ./minimal-functional-fox.nix { inherit pkgs; };
  self-host-fonts = pkgs.callPackage ./self-host-fonts.nix { inherit pkgs; };
in
{
  minimal-functional-fox = minimal-functional-fox;
  self-host-fonts = self-host-fonts;
}
