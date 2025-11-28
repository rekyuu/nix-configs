{
  lib,
  stdenvNoCC,
  fetchzip,
}: stdenvNoCC.mkDerivation rec {
  pname = "bibata-cursor-theme";
  version = "2.0.7";
  dontConfigue = true;

  src = fetchzip {
    url = "https://github.com/ful1e5/Bibata_Cursor/releases/download/v${version}/Bibata.tar.xz";
    hash = "sha256-+xw9+rYqOeBiURmflwlWQDEiwcJP1V5G6VA14shK0XQ=";
    stripRoot = false;
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/icons
    cp -r Bibata* $out/share/icons

    runHook postInstall
  '';

  meta = with lib; {
    description = "Material Based Cursor Theme";
    homepage = "https://github.com/ful1e5/Bibata_Cursor";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl3Plus;
  };
}