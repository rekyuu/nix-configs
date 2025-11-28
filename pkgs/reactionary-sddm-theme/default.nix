{ 
  lib,
  stdenvNoCC,
  fetchgit
}: stdenvNoCC.mkDerivation rec {
  pname = "reactionary-sddm-theme";
  version = "1.0.0";
  
  src = fetchgit {
    url = "https://www.opencode.net/phob1an/reactionary.git";
    sparseCheckout = ["sddm/themes/reactionary"];
    rev = "4aa2d20f0e93ae4387a90947fcc6c90940c18122";
    hash = "sha256-iIuaxUnos4IeXOX4zRmTPP4hWF6i7hW+xvIopRKe964=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sddm/themes
    mv sddm/themes/reactionary $out/share/sddm/themes

    runHook postInstall
  '';

  meta = with lib; {
    description = "Reactionary";
    homepage = "https://www.opencode.net/phob1an/reactionary";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}