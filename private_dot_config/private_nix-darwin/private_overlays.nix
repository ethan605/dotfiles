{
  inputs,
  system,
  ...
}:
let
  pkgs = (import inputs.nixpkgs { system = system; });
  pkgs-2511 = (import inputs.nixpkgs-2511 { system = system; });
  pkgs-direnv = (import inputs.nixpkgs-direnv { system = system; });
in
{
  nixpkgs = {
    overlays = [
      (_: _: {
        mpd = pkgs-2511.mpd;
        direnv = pkgs-direnv.direnv;

        minimal-functional-fox = pkgs.callPackage ./modules/packages/minimal-functional-fox.nix { };
        self-host-fonts = pkgs.callPackage ./modules/packages/self-host-fonts.nix { };
      })
    ];
  };
}
