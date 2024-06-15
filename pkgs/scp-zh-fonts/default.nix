{
  lib,
  stdenvNoCC,
  fetchzip,
}: stdenvNoCC.mkDerivation rec {
  pname = "scp-zh-fonts";
  version = "0.0.0.beta";
  dontConfigue = true;

  src = fetchzip {
    url = "https://github.com/StellarCN/scp_zh/archive/refs/tags/${version}.zip";
    hash = "sha256-WRzJjAQzxeuBBQG3N5XCwzc+1GtnQp9kw8AigrZY4Xg=";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/fonts/scp-zh
    mv fonts/* $out/share/fonts/scp-zh

    runHook postInstall
  '';

  meta = with lib; {
    description = "恒星共识协议中文翻译";
    homepage = "https://github.com/StellarCN/scp_zh";
    maintainers = with maintainers; [rekyuu];
    platforms = platforms.linux;
    license = licenses.unfree;
  };
}