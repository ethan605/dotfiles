{ nixpkgs-master, ... }:
let
  pkgs-master = (import nixpkgs-master { system = "aarch64-darwin"; });
in
{
  nixpkgs = {
    overlays = [
      (self: super: {
        apple-sdk = pkgs-master.apple-sdk;
        # nushell = pkgs-master.nushell;
      })
    ];
  };
}
