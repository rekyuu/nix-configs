{ 
  lib,
  stdenvNoCC,
  fetchgit
}: stdenvNoCC.mkDerivation rec {
  pname = "reactionary-sddm-theme";
  version = "d0294611";
  
  src = fetchgit {
    url = "https://www.opencode.net/phob1an/reactionary.git";
    sparseCheckout = ["sddm/themes/reactionary"];
    rev = "d02946110b87c9c61607ff4913dcbf9d070f6b6a";
    hash = "sha256-zC+6tv/azp8hMLQZuXypIy8zOnbhzI88rAHc+wh2WmM=";
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