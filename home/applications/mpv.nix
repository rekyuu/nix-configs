{
  pkgs,
  ...
}: {
  # https://home-manager.dev/manual/25.05/options.html#opt-programs.mpv.enable
  programs.mpv = {
    enable = true;

    scripts = with pkgs; [
      mpvScripts.builtins.autoload
      mpvScripts.visualizer
    ];

    # bindings = {};

    # config = {};

    scriptOpts = {
      # https://github.com/mpv-player/mpv/blob/v0.40.0/TOOLS/lua/autoload.lua#L19
      autoload = {
        disabled = "no";
      };
    };
  };
}