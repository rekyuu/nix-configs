{
  lib,
  stdenv,
  pkg-config,
  libGL,
  libjpeg,
  libpng,
  mesa,
  wayland,
  xorg,
  fetchFromGitHub,
}:

stdenv.mkDerivation rec {
  pname = "neowall";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "1ay1";
    repo = "neowall";
    rev = "v${version}";
    hash = "sha256-Ybms3++7ql5X/xxfUywp6ClxA7rKlzHYfb13yhORR7E=";
  };

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ libGL libjpeg libpng mesa wayland xorg.libX11 xorg.libXrandr ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 build/bin/neowall $out/bin

    mkdir -p $out/share/neowall/shaders
    for shader in examples/shaders/*.glsl; do
      install -Dm644 $shader $out/share/neowall/shaders/$(basename $shader);
    done

    runHook postInstall
  '';

  meta = with lib; {
    description = "A reliable Wayland wallpaper engine written in C. Multi-monitor support, smooth transitions, hot-reload. For Wayland (Sway, Hyprland, River. and KWin) and X11";
    homepage = "https://github.com/1ay1/neowall";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.mit;
    mainProgram = "neowall";
  };
}
