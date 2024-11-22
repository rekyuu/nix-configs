{
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    (retroarch.override {
      cores = with libretro; [
        citra
        desmume
        dolphin
        gambatte
        mgba
        mupen64plus
        snes9x
      ];
    })
  ];
}