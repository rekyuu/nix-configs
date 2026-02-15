{
  pkgs,
  ...
}: let
  # https://github.com/NixOS/nixpkgs/tree/master/pkgs/applications/emulators/libretro
  retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
    citra
    desmume
    dolphin
    gambatte
    mgba
    mupen64plus
    snes9x
    swanstation
  ]));
in {
  home.packages = with pkgs; [
    retroarchWithCores
  ];
}