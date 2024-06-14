{
  gst_all_1,
  pkgs,
  ...
}: 
let
  dxvkConfig = pkgs.writeTextFile {
    name = "dxvk.conf";
    text = builtins.readFile ./static/dxvk.conf;
  };
in {
  # You can import other home-manager modules here
  imports = [
    ./applications/btop.nix
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
    comma
    dconf
    feh
    fflogs
    firefox
    freerdp3
    gamescope
    gammastep
    gnome.adwaita-icon-theme
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
    (buildEnv { name = "scripts"; paths = [ ./scripts ]; })
    (callPackage ../pkgs/jellyfin-rpc {}) # TODO: config
  ];

  # Nautilus GStreamer stuff
  nixpkgs.overlays = [(self: super: {
    gnome = super.gnome.overrideScope' (gself: gsuper: {
      nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
        buildInputs = nsuper.buildInputs ++ (with gst_all_1; [
          gst-plugins-good
          gst-plugins-bad
        ]);
      });
    });
  })];

  home.file = {
    face = {
      source = ./static/face.png;
      target = ".face";
    };
  };

  home.sessionPath = [ ];

  home.sessionVariables = {
    # fcitx
    # GTK_IM_MODULE = fcitx;
    # QT_IM_MODULE = fcitx;
    # XMODIFIERS = "@im=fcitx";
    # SDL_IM_MODULE = fcitx;
    # GLFW_IM_MODULE = ibus;

    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11";
    NIXOS_OZONE_WL = "1";
    _JAVA_AWT_WM_NONREPARENTING = "1";

    # xivlauncher
    DALAMUD_HOME = "$HOME/.xlcore/dalamud/Hooks/dev";
    DXVK_CONFIG_FILE = dxvkConfig;
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
