{
  pkgs,
  ...
}: let
  retroarchWithCores = (pkgs.retroarch.withCores (cores: with cores; [
    citra
    desmume
    dolphin
    gambatte
    mgba
    mupen64plus
    snes9x
  ]));
in {
  home.packages = with pkgs; [
    retroarchWithCores
  ];
}