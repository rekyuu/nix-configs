# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  inputs,
  lib,
  config,
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./applications/hyprland.nix
    ./applications/kitty.nix
    ./applications/vscode.nix
    ./applications/zsh.nix
  ];

  home = {
    username = "rekyuu";
    homeDirectory = "/home/rekyuu";
  };

  # Add stuff for your user as you see fit:
  # programs.neovim.enable = true;
  home.packages = with pkgs; [
    firefox
    goxlr-utility
    gnome.nautilus
    pavucontrol
    telegram-desktop
    xorg.xrandr
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
    # QT_QPA_PLATFORM = "wayland;xcb";
    # GDK_BACKEND = "wayland,x11";

    # TODO: xivlauncher
    # DALAMUD_HOME = "$HOME/.xlcore/dalamud/Hooks/dev";
    # DXVK_CONFIG_FILE = "$HOME/dxvk.conf";
    # VDPAU_DRIVER = "radeonsi";
    # LIBVA_DRIVER_NAME = "radeonsi";

    MOZ_ENABLE_WAYLAND = 0; # cocksuckers!!
    _JAVA_AWT_WM_NONREPARENTING = 1;
  };

  # Enable home-manager and git
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
