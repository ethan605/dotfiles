{ nixpkgs-2511, nixpkgs-direnv, ... }:
let
  pkgs-2511 = (import nixpkgs-2511 { system = "aarch64-darwin"; });
  pkgs-direnv = (import nixpkgs-direnv { system = "aarch64-darwin"; });
in
{
  nixpkgs = {
    overlays = [
      (self: super: {
        mpd = pkgs-2511.mpd;
        direnv = pkgs-direnv.direnv;
      })
    ];
  };
}
