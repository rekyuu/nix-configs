{
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./applications/hyprland.nix
    ./applications/kitty.nix
    ./applications/mpd.nix
    ./applications/rofi.nix
    ./applications/vscode.nix
    ./applications/waybar.nix
    ./applications/zsh.nix
  ];

  home = {
    username = "rekyuu";
    homeDirectory = "/home/rekyuu";
  };

  qt = {
    enable = true;
  };

  gtk = {
    enable = true;
  };

  home.packages = with pkgs; [
    bc
    btop
    firefox
    freerdp3
    gammastep
    goxlr-utility
    gnome.nautilus
    jq
    lm_sensors
    mpc-cli
    nil
    pavucontrol
    python3
    telegram-desktop
    vesktop
    ymuse
    (callPackage ../pkgs/jellyfin-rpc {})
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    TERM = "xterm-256color";
    # HYPRCURSOR_THEME = "hypr_Bibata-Modern-Classic";
    # HYPRCURSOR_SIZE = "24";
    # XCURSOR_THEME = "Bibata-Modern-Classic";
    # XCURSOR_SIZE = "24";
    # QT_STYLE_OVERRIDE = adwaita-dark;
    # QT_QPA_PLATFORMTHEME = qt5ct;
    # PATH = "$PATH:$HOME/.local/bin:/etc/profile:$HOME/.cargo/bin:$HOME/go/bin:$HOME/.dotnet/tools:$HOME/.pebble-sdk/SDKs/pebble-sdk-4.5-linux64/bin";

    # TODO: fcitx
    # GTK_IM_MODULE = fcitx;
    # QT_IM_MODULE = fcitx;
    # XMODIFIERS = "@im=fcitx";
    # SDL_IM_MODULE = fcitx;
    # GLFW_IM_MODULE = ibus;

    # TODO: maybe these can be configured elsewhere
    EDITOR = "vim";
    VISUAL = "vim";
    SYSTEMD_EDITOR = "vim";

    # TODO: do I need these?
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    NIXOS_OZONE_WL = "1";

    # TODO: xivlauncher
    # DALAMUD_HOME = "$HOME/.xlcore/dalamud/Hooks/dev";
    # DXVK_CONFIG_FILE = "$HOME/dxvk.conf";
    # VDPAU_DRIVER = "radeonsi";
    # LIBVA_DRIVER_NAME = "radeonsi";

    # MOZ_ENABLE_WAYLAND = "0"; # cocksuckers!!
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  programs.bash.enable = true;
  programs.home-manager.enable = true;

  programs.git = {
    enable = true;
    userName = "rekyuu";
    extraConfig = {
      init.defaultBranch = "main";
      commit.gpgsign = true;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
