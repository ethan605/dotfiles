{
  inputs,
  system,
  ...
}:
let
  pkgs = (import inputs.nixpkgs { system = system; });
  pkgs-25-11 = (import inputs.nixpkgs-25-11 { system = system; });
  # pkgs-master = (import inputs.nixpkgs-master { system = system; });
in
{
  nixpkgs = {
    overlays = [
      (_: _: {
        # Overriden packages (due to instabilities, bugs, etc.)
        zsh = pkgs-25-11.zsh;

        # Self-host packages
        minimal-functional-fox = pkgs.callPackage ./modules/packages/minimal-functional-fox.nix { };
        self-host-fonts = pkgs.callPackage ./modules/packages/self-host-fonts.nix { };
      })
    ];
  };
}
