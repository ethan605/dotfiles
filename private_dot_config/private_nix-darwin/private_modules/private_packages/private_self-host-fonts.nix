{ pkgs }:

pkgs.stdenvNoCC.mkDerivation {
  pname = "self-host-fonts";
  version = "1.0.0";

  src = pkgs.fetchFromGitHub {
    owner = "ethan605";
    repo = "arch-pkgs";
    rev = "28b526465890292891c0299a31febebb6803c04b";
    fetchLFS = true;
    hash = "sha256-mqlGC3LObXuGP3hiz0s911jOl2r2HWKq6sec07G9OPg=";
  };

  unpackPhase = ''
    runHook preUnpack

    # Nothing to do

    runHook postUnpack
  '';

  installPhase = ''
    runHook preInstall

    install -Dm444 $src/fonts/otf-operator-mono-ssm-nerd/*.otf -t $out/share/fonts/opentype/
    install -Dm444 $src/fonts/ttf-samsung-sans-nerd/*.ttf -t $out/share/fonts/truetype/

    runHook postInstall
  '';

  meta = with pkgs.lib; {
    description = "My self-host fonts";
    homepage = "https://github.com/ethan605/arch-pkgs/tree/main/fonts";
    platforms = platforms.all;
  };
}
