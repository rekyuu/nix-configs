{...}:
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";
  vr = "DP-3";
in {
  services.mako = {
    enable = true;

    settings = {
      output = monitorC;
      sort = "-time";
      layer = "overlay";
      default-timeout = 5000;
      ignore-timeout = true;

      font = "Noto Sans 14";
      background-color = "#00000075";

      padding = "15";
      width = 450;
      height = 110;

      border-color = "#00000000";
      border-size = 0;
      border-radius = 0;

      icons = false;
      max-icon-size = 64;

      "urgency=low" = {
        border-color = "#cccccc00";
      };

      "urgency=normal" = {
        border-color = "#d0877000";
      };

      "urgency=high" = {
        border-color = "#bf616a00";
        default-timeout = 0;
      };

      "category=mpd" = {
        default-timeout = 2000;
        group-by = "category";
      };

      "category=volume" = {
        width = 300;
        text-alignment = "center";
        anchor = "bottom-center";
        margin = "0,0,200,0";
        group-by = "category";
      };
    };
  };
}