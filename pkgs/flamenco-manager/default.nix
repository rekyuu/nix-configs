{
  lib,
  stdenv,
  fetchzip,
  ffmpeg
}: stdenv.mkDerivation rec {
  pname = "flamenco-manager";
  version = "3.9.2";

  src = fetchzip {
    url = "https://flamenco.blender.org/downloads/flamenco-${version}-linux-amd64.tar.gz";
    hash = "sha256-Oy7akssWDwuvPGquVTRFo0cBatA9Tg3yLXii6+KijSI=";
  };

  buildInputs = [ ffmpeg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 flamenco-manager $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "";
    homepage = "https://flamenco.blender.org/";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    mainProgram = "flamenco-manager";
  };
}