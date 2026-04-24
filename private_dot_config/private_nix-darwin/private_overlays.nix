{
  inputs,
  system,
  ...
}:
let
  pkgs = (import inputs.nixpkgs { system = system; });
  pkgs-25-11 = (import inputs.nixpkgs-25-11 { system = system; });
  pkgs-direnv = (import inputs.nixpkgs-direnv { system = system; });
in
{
  nixpkgs = {
    overlays = [
      (_: _: {
        mpd = pkgs-25-11.mpd;
        zsh = pkgs-25-11.zsh;
        direnv = pkgs-direnv.direnv;

        minimal-functional-fox = pkgs.callPackage ./modules/packages/minimal-functional-fox.nix { };
        self-host-fonts = pkgs.callPackage ./modules/packages/self-host-fonts.nix { };
      })
    ];
  };
}
