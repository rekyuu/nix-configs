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
    rev = "9607954efe880c052bbbf7d0ea12fc62fd5c9f0d";
    hash = "sha256-eScJjh2TKvcH8cQc86s2HEyxBOfK2eAOyg5T7qfLvdk=";
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
    maintainers = with maintainers; [rekyuu];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}