{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    (steam.override { # https://github.com/NixOS/nixpkgs/issues/162562#issuecomment-1523177264
      extraPkgs = pkgs: with pkgs; [
        xorg.libXcursor
        xorg.libXi
        xorg.libXinerama
        xorg.libXScrnSaver
        gamemode
        libpng
        libpulseaudio
        libvorbis
        stdenv.cc.cc.lib
        libkrb5
        keyutils
        wqy_zenhei
      ];
    })
    steamtinkerlaunch
  ];

  xdg.dataFile = {
    "Steam/compatibilitytools.d/SteamTinkerLaunch/compatibilitytool.vdf".text = ''
      "compatibilitytools"
      {
        "compat_tools"
        {
          "Proton-stl" // Internal name of this tool
          {
            "install_path" "."
            "display_name" "Steam Tinker Launch"
                                                                                   
            "from_oslist"  "windows"
            "to_oslist"    "linux"
          }
        }
      }
    '';
    "Steam/compatibilitytools.d/SteamTinkerLaunch/steamtinkerlaunch".source = config.lib.file.mkOutOfStoreSymlink "${pkgs.steamtinkerlaunch}/bin/steamtinkerlaunch";
    "Steam/compatibilitytools.d/SteamTinkerLaunch/toolmanifest.vdf".text = ''
      "manifest"
      {
        "commandline" "/steamtinkerlaunch run"
        "commandline_waitforexitandrun" "/steamtinkerlaunch waitforexitandrun"
      }
    '';
  };
}