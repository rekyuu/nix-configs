{
  pkgs,
  ...
}:
let
  hyprConfig = pkgs.writeTextFile {
    name = "hyprland.lua";
    text = builtins.readFile ../static/hypr/hyprland.lua;
  };
in {
  home.packages = with pkgs; [
    grim
    grimblast
    hyprpicker
    hyprshutdown
    slurp
    wf-recorder
    wl-clipboard
    xhost
    xprop
    xrandr
  ];

  xdg = {
    configFile."hypr/hyprland.lua" = {
      force = true;
      source =
        pkgs.runCommand "hyprland-config-check"
          {
            nativeBuildInputs = [ pkgs.hyprland ];
          }
          ''
            export XDG_RUNTIME_DIR="/run/user/1000"

            hyprland --config ${hyprConfig} --verify-config
            cp ${hyprConfig} $out
          '';
    };
  };
}