{ nixpkgs-master, ... }:
let
  pkgs-master = (import nixpkgs-master { system = "aarch64-darwin"; });
in
{
  nixpkgs = {
    overlays = [
      (self: super: {
        nushell = pkgs-master.nushell;
      })
    ];
  };
}
