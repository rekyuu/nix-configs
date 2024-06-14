{
  pkgs,
  ...
}: {
  # You can import other home-manager modules here
  imports = [
    ./applications/hyprlock.nix
    ./applications/hyprpaper.nix
    ./applications/kitty.nix
    ./applications/mako.nix
    ./applications/mpd.nix
    ./applications/rofi.nix
    ./applications/sway.nix
    ./applications/vscode.nix
    ./applications/waybar.nix
    ./applications/zsh.nix
  ];

  home = {
    username = "rekyuu";
    homeDirectory = "/home/rekyuu";

    pointerCursor = {
      gtk.enable = true;
      x11.enable = true;

      name = "Bibata-Modern-Classic";
      size = 24;
      package = pkgs.callPackage ../pkgs/bibata-cursor-theme {};
    };
  };

  gtk = {
    enable = true;
    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "gtk3";
    style = {
      name = "adwaita-dark";
      package = pkgs.adwaita-qt;
    };
  };

  home.packages = with pkgs; [
    bc
    blender-hip
    btop
    comma
    dconf
    feh
    fflogs
    firefox
    freerdp3
    gamescope
    gammastep
    gnome.gnome-calculator
    gnome.gnome-clocks
    gnome.nautilus
    gnome.seahorse
    goxlr-utility
    grim
    jetbrains.clion
    jetbrains.datagrip
    jetbrains.pycharm-professional
    jetbrains.rider
    jq
    libnotify
    lm_sensors
    networkmanagerapplet
    networkmanager-openvpn
    mpc-cli
    nil
    pavucontrol
    prismlauncher # minecraft
    python3
    slurp
    steam
    telegram-desktop
    transmission-qt
    ungoogled-chromium
    vesktop
    xivlauncher
    wf-recorder
    wl-clipboard
    ymuse
    (callPackage ../pkgs/jellyfin-rpc {})
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
  ];

  home.sessionVariables = {
    TERM = "xterm-256color";
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

  programs = {
    bash.enable = true;

    git = {
      enable = true;
      userName = "rekyuu";
      extraConfig = {
        init.defaultBranch = "main";
        commit.gpgsign = true;
      };
    };

    home-manager.enable = true;
  };

  services = {
    gpg-agent = {
      enable = true;
      pinentryPackage = pkgs.pinentry-gnome3;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
