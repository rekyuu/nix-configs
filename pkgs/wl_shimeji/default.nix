{ 
  lib,
  fetchgit,
  pkg-config,
  python3Packages,
  wayland,
  wayland-protocols,
  wayland-scanner,
  wlr-protocols,
  which
}: with python3Packages; buildPythonApplication {
  pname = "wl_shimeji";
  version = "0.0.1.r104.651e296";
  format = "other";
  
  src = fetchgit {
    url = "https://github.com/CluelessCatBurger/wl_shimeji";
    rev = "651e2962902cc1c71a1a5ee7e61ea2633625e7aa";
    hash = "sha256-BvAlP9SHtl5bb/VQn2XBQh/l+ewSQvoYzX37uUBKLQQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    pkg-config
    which
  ];

  buildInputs = [
    wayland
    wayland-protocols
    wayland-scanner
    wlr-protocols
  ];

  dependencies = [
    pillow
  ];

  buildPhase = ''
    unset CFLAGS
    CFLAGS+=" -O2 "
    make all
  '';

  installPhase = ''
    make DESTDIR="$out/" PREFIX="" install
    make DESTDIR="$out/" PREFIX="" install_plugins
  '';

  meta = with lib; {
    description = "Shimeji reimplementation for Wayland in C ";
    homepage = "https://github.com/CluelessCatBurger/wl_shimeji";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    mainProgram = "shimejictl";
  };
}