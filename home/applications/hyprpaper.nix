{...}: 
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      preload = ["~/Pictures/wallhaven-zxvkmy.jpg"];
      wallpaper = [
        "${monitorL},~/Pictures/wallhaven-zxvkmy.jpg"
        "${monitorC},~/Pictures/wallhaven-zxvkmy.jpg"
        "${monitorR},~/Pictures/wallhaven-zxvkmy.jpg"
      ];
    };
  };
}