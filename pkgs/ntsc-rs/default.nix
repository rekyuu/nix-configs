{
  lib,
  stdenv,
  rustPlatform,
  fetchgit,
  pkg-config,
  makeWrapper,
  gst_all_1,
  openssl,
  expat,
  fontconfig,
  freetype,
  libGL,
  xorg,
  wayland,
  libxkbcommon,
  vulkan-loader
}: let
  target = stdenv.hostPlatform.rust.rustcTargetSpec;
in rustPlatform.buildRustPackage rec {
  pname = "ntsc-rs";
  version = "0.9.4";

  src = fetchgit {
    url = "https://github.com/ntsc-rs/ntsc-rs";
    rev = "v${version}";
    fetchSubmodules = true;
    hash = "sha256-t65pE7Nk1It4Irhh8JXM+/+ewOGjok5HkmJPUg8tBEg=";
  };

  cargoHash = "sha256-MAaUrEbRNHZ5IMKUxr22HLacJG3YNvhuVfXyOoa+HEE=";

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
    makeWrapper
    openssl
  ];

  buildInputs = [
    gst_all_1.gstreamer
    gst_all_1.gst-libav
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    gst_all_1.gst-plugins-bad
    gst_all_1.gst-plugins-ugly
    openssl

    # iced deps: https://github.com/iced-rs/iced/blob/fd5ed0d0a6e84b3c036ff8e1f0d62d383d4b1e82/DEPENDENCIES.md#nixos
    expat
    fontconfig
    freetype
    freetype.dev
    libGL
    xorg.libX11
    xorg.libXcursor
    xorg.libXi
    xorg.libXrandr
    wayland
    libxkbcommon
    vulkan-loader
  ];

  cargoBuildFlags = [
    "--package"
    "ntsc-rs-gui"
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    install -Dm755 target/${target}/release/ntsc-rs-standalone $out/bin
    install -Dm755 target/${target}/release/ntsc-rs-cli $out/bin

    runHook postInstall
  '';

  postFixup = ''
    wrapProgram $out/bin/ntsc-rs-standalone \
      --suffix LD_LIBRARY_PATH : ${builtins.foldl' (a: b: "${a}:${b}/lib") "${vulkan-loader}/lib" buildInputs}
    wrapProgram $out/bin/ntsc-rs-cli \
      --suffix LD_LIBRARY_PATH : ${builtins.foldl' (a: b: "${a}:${b}/lib") "${vulkan-loader}/lib" buildInputs}
  '';

  meta = with lib; {
    description = "Free, open-source VHS effect. Standalone application + plugin (After Effects, Premiere, and OpenFX). ";
    homepage = "https://github.com/ntsc-rs/ntsc-rs";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.mit;
    mainProgram = "ntsc-rs-standalone";
  };
}
