{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "minimal-functional-fox";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "ethan605";
    repo = "minimal-functional-fox";
    rev = "2b57ca12e8b9596f7e8109238ac9dc6bb1575edb";
    hash = "sha256-ZwZ2PqP+2Zn0zCTokyEB4fLWm0f5vwLaIhKSpENEy3s=";
  };

  unpackPhase = ''
    runHook preUnpack

    # Nothing to do

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 $src/*.svg -t $out/
    install -Dm444 $src/*.css -t $out/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "A minimal, yet functional Firefox userChrome configuration";
    homepage = "https://github.com/ethan605/minimal-functional-fox";
    platforms = platforms.all;
  };
}

