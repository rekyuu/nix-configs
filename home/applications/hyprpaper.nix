{
  pkgs,
  ...
}: let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";

  wallpaper = builtins.path {
    name = "wallpaper.jpg";
    path = ../static/wallhaven-k9rqp7.jpg;
  };
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = [ wallpaper ];
      wallpaper = [
        "${monitorL},${wallpaper}"
        "${monitorC},${wallpaper}"
        "${monitorR},${wallpaper}"
      ];
    };
  };
}