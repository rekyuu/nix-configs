{
  stdenv,
  cmake,
  lsb-release,
  ninja,
  lib,
  fetchFromGitHub,
  fetchurl,
  copyDesktopItems,
  makeDesktopItem,
  python3,
  libX11,
  libXrandr,
  libXinerama,
  libXcursor,
  libXi,
  libXext,
  glew,
  boost,
  SDL2,
  SDL2_net,
  pkg-config,
  libpulseaudio,
  libpng,
  imagemagick,
  zenity,
  makeWrapper,
  darwin,
  apple-sdk_11,
  libicns,
  libzip,
  nlohmann_json,
  tinyxml-2,
  spdlog
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "shipwright";
  version = "let-it-snow-2024";

  src = fetchFromGitHub {
    owner = "harbourmasters";
    repo = "shipwright";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-n9pAAUPGecMeVZhYT8u6LSrJMG/MfAwsLFvRbIJNg44=";
    fetchSubmodules = true;
  };

  patches = [
    ./darwin-fixes.patch
  ];

  # This would get fetched at build time otherwise, see:
  # https://github.com/HarbourMasters/Shipwright/blob/e46c60a7a1396374e23f7a1f7122ddf9efcadff7/soh/CMakeLists.txt#L736
  gamecontrollerdb = fetchurl {
    name = "gamecontrollerdb.txt";
    url = "https://raw.githubusercontent.com/gabomdq/SDL_GameControllerDB/e9d11d9bdbdd19269b18d85908bd96525a3cb277/gamecontrollerdb.txt";
    hash = "sha256-X5vyQ4B/VO8lXbTkpLw3vY0AdIYn5zHI1FeVZeNnWoU=";
  };

  # https://github.com/Kenix3/libultraship/blob/60868949e62a4c4c863eb5daf883bae18387f372/cmake/dependencies/common.cmake#L19
  imgui = fetchFromGitHub {
    owner = "ocornut";
    repo = "imgui";
    rev = "refs/tags/v1.90.6-docking";
    hash = "sha256-Y8lZb1cLJF48sbuxQ3vXq6GLru/WThR78pq7LlORIzc=";
  };

  # https://github.com/Kenix3/libultraship/blob/60868949e62a4c4c863eb5daf883bae18387f372/cmake/dependencies/common.cmake#L55
  stormlib = fetchFromGitHub {
    owner = "ladislav-zezula";
    repo = "StormLib";
    rev = "refs/tags/v9.25";
    hash = "sha256-HTi2FKzKCbRaP13XERUmHkJgw8IfKaRJvsK3+YxFFdc=";
  };

  # https://github.com/Kenix3/libultraship/blob/60868949e62a4c4c863eb5daf883bae18387f372/cmake/dependencies/common.cmake#L82
  libgfxd = fetchFromGitHub {
    owner = "glankk";
    repo = "libgfxd";
    rev = "008f73dca8ebc9151b205959b17773a19c5bd0da";
    hash = "sha256-AmHAa3/cQdh7KAMFOtz5TQpcM6FqO9SppmDpKPTjTt8=";
  };

  # https://github.com/Kenix3/libultraship/blob/60868949e62a4c4c863eb5daf883bae18387f372/cmake/dependencies/common.cmake#L109
  threadpool = fetchFromGitHub {
    owner = "bshoshany";
    repo = "thread-pool";
    rev = "refs/tags/v4.1.0";
    hash = "sha256-zhRFEmPYNFLqQCfvdAaG5VBNle9Qm8FepIIIrT9sh88=";
  };

  nativeBuildInputs =
    [
      cmake
      ninja
      pkg-config
      python3
      imagemagick
      makeWrapper
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      lsb-release
      copyDesktopItems
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libicns
      darwin.sigtool
    ];

  buildInputs =
    [
      boost
      glew
      SDL2
      SDL2_net
      libpng
      libzip
      nlohmann_json
      tinyxml-2
      spdlog
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libX11
      libXrandr
      libXinerama
      libXcursor
      libXi
      libXext
      libpulseaudio
      zenity
    ]
    ++ lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

  cmakeFlags = [
    (lib.cmakeBool "NON_PORTABLE" true)
    (lib.cmakeFeature "CMAKE_INSTALL_PREFIX" "${placeholder "out"}/lib")
    "-DFETCHCONTENT_SOURCE_DIR_IMGUI=${finalAttrs.imgui}"
    "-DFETCHCONTENT_SOURCE_DIR_STORMLIB=${finalAttrs.stormlib}"
    "-DFETCHCONTENT_SOURCE_DIR_LIBGFXD=${finalAttrs.libgfxd}"
    "-DFETCHCONTENT_SOURCE_DIR_THREADPOOL=${finalAttrs.threadpool}"
  ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isDarwin "-Wno-int-conversion -Wno-implicit-int";

  dontAddPrefix = true;

  # Linking fails without this
  hardeningDisable = [ "format" ];

  postBuild = ''
    cp ${finalAttrs.gamecontrollerdb} ${finalAttrs.gamecontrollerdb.name}
    pushd ../OTRExporter
    python3 ./extract_assets.py -z ../build/ZAPD/ZAPD.out --norom --xml-root ../soh/assets/xml --custom-assets-path ../soh/assets/custom --custom-otr-file soh.otr --port-ver ${finalAttrs.version}
    popd
  '';

  preInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # Cmake likes it here for its install paths
      cp ../OTRExporter/soh.otr ..
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      cp ../OTRExporter/soh.otr soh/soh.otr
    '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      mkdir -p $out/bin
      ln -s $out/lib/soh.elf $out/bin/soh
      install -Dm644 ../soh/macosx/sohIcon.png $out/share/pixmaps/soh.png
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      # Recreate the macOS bundle (without using cpack)
      # We mirror the structure of the bundle distributed by the project

      mkdir -p $out/Applications/soh.app/Contents
      cp $src/soh/macosx/Info.plist.in $out/Applications/soh.app/Contents/Info.plist
      substituteInPlace $out/Applications/soh.app/Contents/Info.plist \
        --replace-fail "@CMAKE_PROJECT_VERSION@" "${finalAttrs.version}"

      mv $out/MacOS $out/Applications/soh.app/Contents/MacOS

      # Wrapper
      cp $src/soh/macosx/soh-macos.sh.in $out/Applications/soh.app/Contents/MacOS/soh
      chmod +x $out/Applications/soh.app/Contents/MacOS/soh
      patchShebangs $out/Applications/soh.app/Contents/MacOS/soh

      # "lib" contains all resources that are in "Resources" in the official bundle.
      # We move them to the right place and symlink them back to $out/lib,
      # as that's where the game expects them.
      mv $out/Resources $out/Applications/soh.app/Contents/Resources
      mv $out/lib/** $out/Applications/soh.app/Contents/Resources
      rm -rf $out/lib
      ln -s $out/Applications/soh.app/Contents/Resources $out/lib

      # Copy icons
      cp -r ../build/macosx/soh.icns $out/Applications/soh.app/Contents/Resources/soh.icns

      # Fix executable
      install_name_tool -change @executable_path/../Frameworks/libSDL2-2.0.0.dylib \
                        ${SDL2}/lib/libSDL2-2.0.0.dylib \
                        $out/Applications/soh.app/Contents/Resources/soh-macos
      install_name_tool -change @executable_path/../Frameworks/libGLEW.2.2.0.dylib \
                        ${glew}/lib/libGLEW.2.2.0.dylib \
                        $out/Applications/soh.app/Contents/Resources/soh-macos
      install_name_tool -change @executable_path/../Frameworks/libpng16.16.dylib \
                        ${libpng}/lib/libpng16.16.dylib \
                        $out/Applications/soh.app/Contents/Resources/soh-macos

      # Codesign (ad-hoc)
      codesign -f -s - $out/Applications/soh.app/Contents/Resources/soh-macos
    '';

  fixupPhase = lib.optionalString stdenv.hostPlatform.isLinux ''
    wrapProgram $out/lib/soh.elf --prefix PATH ":" ${lib.makeBinPath [ zenity ]}
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "soh";
      icon = "soh";
      exec = "soh";
      comment = finalAttrs.meta.description;
      genericName = "Ship of Harkinian";
      desktopName = "soh";
      categories = [ "Game" ];
    })
  ];

  meta = {
    homepage = "https://github.com/HarbourMasters/Shipwright";
    description = "A PC port of Ocarina of Time with modern controls, widescreen, high-resolution, and more";
    mainProgram = "soh";
    platforms = [ "x86_64-linux" ] ++ lib.platforms.darwin;
    maintainers = with lib.maintainers; [
      j0lol
      matteopacini
    ];
    license = with lib.licenses; [
      # OTRExporter, OTRGui, ZAPDTR, libultraship
      mit
      # Ship of Harkinian itself
      unfree
    ];
  };
})
