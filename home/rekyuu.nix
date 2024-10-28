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
  imports = [
    ./applications/bspwm.nix
    ./applications/btop.nix
    ./applications/goxlr.nix
    ./applications/hyprland.nix
    ./applications/hyprlock.nix
    ./applications/hyprpaper.nix
    ./applications/i3.nix
    ./applications/jellyfin-rpc.nix
    ./applications/kitty.nix
    ./applications/mpd.nix
    ./applications/obs.nix
    ./applications/rofi.nix
    ./applications/steam.nix
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
    bottles
    bruno
    comma
    dconf
    discord
    (with dotnetCorePackages; combinePackages [
      sdk_6_0
      sdk_8_0
    ])
    (callPackage ../pkgs/dotnet-ef {})
    feh
    fflogs
    ffmpeg_7-full
    firefox
    freerdp3
    gamemode
    gamescope
    gammastep
    glaxnimate
    gimp
    gnome.adwaita-icon-theme
    gnome.gnome-calculator
    gnome.gnome-clocks
    gnome.nautilus
    gnome.seahorse
    imagemagick
    jetbrains.clion
    jetbrains.datagrip
    jetbrains.pycharm-professional
    jetbrains.rider
    jq
    kdePackages.kdenlive
    libnotify
    libwebp
    lm_sensors
    lutris
    networkmanagerapplet
    networkmanager-openvpn
    mpc-cli
    nil
    pavucontrol
    prismlauncher # minecraft
    protontricks
    protonup-qt
    python3
    rclone
    runelite
    rsgain
    telegram-desktop
    terraform
    transmission-qt
    ungoogled-chromium
    vesktop
    viewnior
    vlc
    winetricks
    xivlauncher
    # (callPackage ../pkgs/xivlauncher {}) # manually building cause of expansion
    ymuse
    yt-dlp
    (buildEnv { name = "scripts"; paths = [ ./scripts ]; })
  ];

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

  nix.gc = {
    automatic = true;
    frequency = "weekly";
    options = "--delete-older-than 30d";
  };

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

    _JAVA_AWT_WM_NONREPARENTING = "1";

    # xivlauncher
    DALAMUD_HOME = "$HOME/.xlcore/dalamud/Hooks/dev";
    DXVK_CONFIG_FILE = dxvkConfig;
  };

  xdg = {
    mimeApps = {
      enable = true;
      
      defaultApplications = {
        "text/html" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
        "inode/directory" = [ "nautilus-folder-handler.desktop" ];
        "image/jpeg" = [ "viewnior.desktop" ];
        "image/png" = [ "viewnior.desktop" ];
        "image/gif" = [ "viewnior.desktop" ];
        "image/tiff" = [ "viewnior.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "application/x-blender" = [ "blender.desktop" ];
      };
    };
  };

  services = {
    arrpc.enable = true;

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
