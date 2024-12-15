{
  pkgs,
  ...
}: {
  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      decklinkSupport = true;
    };

    plugins = with pkgs.obs-studio-plugins; [
      input-overlay
      obs-3d-effect
      obs-backgroundremoval
      obs-composite-blur
      obs-livesplit-one
      obs-shaderfilter
      obs-vkcapture
    ];
  };
}