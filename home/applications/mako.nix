{...}:
let
  monitorL = "HDMI-A-1";
  monitorC = "DP-1";
  monitorR = "DP-2";
  vr = "DP-3";
in {
  services.mako = {
    enable = true;

    output = monitorC;
    sort = "-time";
    layer = "overlay";
    defaultTimeout = 5000;
    ignoreTimeout = true;

    font = "Noto Sans 14";
    backgroundColor = "#00000075";

    padding = "15";
    width = 450;
    height = 110;

    borderColor = "#00000000";
    borderSize = 0;
    borderRadius = 0;

    icons = false;
    maxIconSize = 64;

    extraConfig = ''
      [urgency=low]
      border-color=#cccccc00

      [urgency=normal]
      border-color=#d0877000

      [urgency=high]
      border-color=#bf616a00
      default-timeout=0

      [category=mpd]
      default-timeout=2000
      group-by=category

      [category=volume]
      width=300
      text-alignment=center
      anchor=bottom-center
      margin=0,0,200,0
      group-by=category
    '';
  };
}