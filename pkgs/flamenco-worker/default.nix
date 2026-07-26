{
  lib,
  stdenv,
  fetchzip,
  ffmpeg
}: stdenv.mkDerivation rec {
  pname = "flamenco-worker";
  version = "3.9.3";

  src = fetchzip {
    url = "https://flamenco.blender.org/downloads/flamenco-${version}-linux-amd64.tar.gz";
    hash = "sha256-BXfwitzygeEo5zct1vRBomjnZZnHxuCK2JVbCmB18vE=";
  };

  buildInputs = [ ffmpeg ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 flamenco-worker $out/bin

    runHook postInstall
  '';

  meta = with lib; {
    description = "";
    homepage = "https://flamenco.blender.org/";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
    mainProgram = "flamenco-worker";
  };
}