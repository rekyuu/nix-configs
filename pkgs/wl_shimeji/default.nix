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
  version = "8ae15cf7";
  format = "other";
  
  src = fetchgit {
    url = "https://github.com/CluelessCatBurger/wl_shimeji";
    rev = "8ae15cf7e56325b08708e1b8d851baef679962d1";
    hash = "sha256-dNShG6SS1jiT0JpI817TSIS7v1JLHSY8T04vhGpD6xo=";
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