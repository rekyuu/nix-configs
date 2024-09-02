{
  pkgs,
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
        steamtinkerlaunch
        libkrb5
        keyutils
        wqy_zenhei
      ];
    })    
  ];
}