{
  lib,
  stdenv,
  pkg-config,
  fetchFromGitHub,
  fetchzip,
  nlohmann_json,
  xxHash,
  cmake,
  wayland,
  libGL,
  libX11,
  libXcursor,
  libxi,
  libxcb,
  libxrandr,
  libxscrnsaver,
  libxtst,
  libjpeg8,
  libxkbcommon,
  libglvnd,
  cxxopts,
  abseil-cpp,
  sdl3,
  fmt,
  tracy,
  freetype,
  zstd
}:

# https://github.com/TwilitRealm/dusk/blob/main/flake.nix
stdenv.mkDerivation rec {
  pname = "dusk";
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "TwilitRealm";
    repo = "dusk";
    rev = "v${version}";
    hash = "sha256-lTvtYeQsptpjI3RuyfmlVKkdfxVMgMZkjv/KUzy1h2k=";
  };

  # Dependencies that are not packaged in nixpkgs:
  aurora-src = fetchFromGitHub {
    owner = "encounter";
    repo = "aurora";
    rev = "63606a43265a3bc18dafd500ab4d7a2108f109e6";
    hash = "sha256-xBvnAwGwNzav67Ac6oUz7RqDUwqgL2bsME3OOMn8Tqw=";
  };

  dawn-src = fetchzip {
    url = "https://github.com/encounter/dawn-build/releases/download/v20260423.175430/dawn-linux-x86_64.tar.gz";
    hash = "sha256-HXfKTLHtMPwupnFnaflCARtXVPuS/0PoCePXidjE5xs=";
    stripRoot = false;
  };

  nod-src = fetchzip {
    url = "https://github.com/encounter/nod/releases/download/v2.0.0-alpha.8/libnod-linux-x86_64.tar.gz";
    hash = "sha256-mUqvLsbsqaZ+HAjMmHYPYO+MgtanGRTw7Gzn5uXR5rE=";
    stripRoot = false;
  };

  # The version of imgui on nixpkgs does not map cleanly.
  imgui-src = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "v1.91.9b-docking";
    hash = "sha256-mQOJ6jCN+7VopgZ61yzaCnt4R1QLrW7+47xxMhFRHLQ=";
  };

  sqlite-src = fetchzip {
    url = "https://sqlite.org/2026/sqlite-amalgamation-3510300.zip";
    hash = "sha256-pNMR8zxaaqfAzQ0AQBOXMct4usdjey1Q0Gnitg06UhM=";
  };

  rmlui-src = fetchzip {
    url = "https://github.com/mikke89/RmlUi/archive/f9b8c9e2935d5df2c7dff2c190d3968e99b0c3dc.tar.gz";
    hash = "sha256-g4O/JZUrrcseOz8o2QJRt+2CeuiLnVeuDJc906xvuIg=";
  };

  postUnpack = ''
    mkdir -p $sourceRoot/extern/aurora
    cp -r ${aurora-src}/. $sourceRoot/extern/aurora/
    chmod -R u+w $sourceRoot/extern/aurora
    sed -i '/add_subdirectory(tests)/d' $sourceRoot/extern/aurora/CMakeLists.txt
  '';

  # Remove last line to re-enable tests
  cmakeFlags = [
    "-DFETCHCONTENT_FULLY_DISCONNECTED=ON"
    "-DFETCHCONTENT_SOURCE_DIR_CXXOPTS=${cxxopts.src}"
    "-DFETCHCONTENT_SOURCE_DIR_JSON=${nlohmann_json.src}"
    "-DFETCHCONTENT_SOURCE_DIR_DAWN_PREBUILT=${dawn-src}"
    "-DFETCHCONTENT_SOURCE_DIR_XXHASH=${xxHash.src}"
    "-DFETCHCONTENT_SOURCE_DIR_FMT=${fmt.src}"
    "-DFETCHCONTENT_SOURCE_DIR_TRACY=${tracy.src}"
    "-DAURORA_SDL3_PROVIDER=system"
    "-DFETCHCONTENT_SOURCE_DIR_NOD_PREBUILT=${nod-src}"
    "-DAURORA_NOD_PROVIDER=package"
    "-DFETCHCONTENT_SOURCE_DIR_FREETYPE=${freetype.src}"
    "-DFETCHCONTENT_SOURCE_DIR_ZSTD=${zstd.src}"
    "-DFETCHCONTENT_SOURCE_DIR_SQLITE3=${sqlite-src}"
    "-DFETCHCONTENT_SOURCE_DIR_IMGUI=${imgui-src}"
    "-DFETCHCONTENT_SOURCE_DIR_RMLUI=${rmlui-src}"
    "-DCMAKE_CROSSCOMPILING=ON" # Tests are not working as I didn't want to work through getting google's test suite working as well. This is the only guard I could find to disable it.
  ];

  installPhase = ''
    mkdir -p $out/bin
    cp dusk $out/bin/dusk
    cp -r ./res $out/bin/res
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    wayland
  ];

  buildInputs = [
    libGL
    libX11
    libXcursor
    libxi
    libxcb
    libxrandr
    libxscrnsaver
    libxtst
    libjpeg8
    libxkbcommon
    libglvnd
    cxxopts
    abseil-cpp
    sdl3
    fmt
    tracy
    freetype
    zstd
  ];

  meta = with lib; {
    description = "Dusk brings a classic adventure to PC and mobile platforms with a variety of fixes and improvements.";
    homepage = "https://github.com/TwilitRealm/dusk";
    maintainers = with maintainers; [ rekyuu ];
    platforms = platforms.linux;
    license = licenses.cc0;
    mainProgram = "dusk";
  };
}
