{ nixpkgs-2511-darwin, ... }:
let
  pkgs-2511 = (import nixpkgs-2511-darwin { system = "aarch64-darwin"; });
in
{
  nixpkgs = {
    overlays = [
      (self: super: {
        apple-sdk = pkgs-2511.apple-sdk;
      })
    ];
  };
}
