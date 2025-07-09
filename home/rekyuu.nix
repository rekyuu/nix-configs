{
  pkgs,
  ...
}: 
let
  dxvkConfig = pkgs.writeTextFile {
    name = "dxvk.conf";
    text = builtins.readFile ./static/dxvk.conf;
  };
  vesktop-version = "3982e122a7f8e95d4e639ec7744393a8eebd437b";
in {
  imports = [
    ./applications/btop.nix
    ./applications/goxlr.nix
    ./applications/hyprlock.nix
    ./applications/hyprpaper.nix
    ./applications/jellyfin-rpc.nix
    ./applications/kitty.nix
    ./applications/mpd.nix
    ./applications/obs.nix
    ./applications/retroarch.nix
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
    adwaita-icon-theme
    archipelago
    audacity
    bc
    blender-hip
    bottles
    bruno
    cantata
    comma
    dconf
    direnv
    feh
    fflogs
    # (callPackage ../pkgs/fflogs {})
    ffmpeg_7-full
    firefox
    freerdp3
    gamemode
    gamescope
    gammastep
    glaxnimate
    gimp
    gnome-calculator
    gnome-clocks
    godot_4
    godot_4-mono
    imagemagick
    iotop
    jetbrains.clion
    jetbrains.datagrip
    jetbrains.idea-ultimate
    jetbrains.pycharm-professional
    jetbrains.rider
    jq
    kdePackages.kdenlive
    kdiskmark
    kubectl
    libnotify
    libreoffice-qt
    libwebp
    lm_sensors
    lsof
    lutris
    nautilus
    networkmanagerapplet
    networkmanager-openvpn
    nix-direnv
    mpc-cli
    mpv
    nil
    nomacs
    obsidian
    pavucontrol
    prismlauncher # minecraft
    protontricks
    protonup-qt
    python3
    rawtherapee
    rclone
    runelite
    rsgain
    seahorse
    shipwright
    _2ship2harkinian
    # sm64ex-coop
    telegram-desktop
    terraform
    transmission_4-qt
    ungoogled-chromium
    (vesktop.overrideAttrs (_: {
      version = vesktop-version;
      src = fetchFromGitHub {
        owner = "Vencord";
        repo = "Vesktop";
        rev = vesktop-version;
        hash = "sha256-aQC/vy23eEZtosuhOk7Ciz2dIze5UfoqcBLAjIrWIPs=";
      };
    }))
    viewnior
    vlc
    nur.repos.ataraxiasjel.waydroid-script
    (wineWowPackages.full.override {
      wineRelease = "staging";
      mingwSupport = true;
    })
    winetricks
    wl-mirror
    (callPackage ../pkgs/wl_shimeji {})
    xivlauncher
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

    # obs-vkcapture
    # OBS_VKCAPTURE = "1";
  };

  xdg = {
    desktopEntries = {
      blender = {
        name = "blender";
        exec = "${pkgs.blender}/bin/blender";
      };

      firefox = {
        name = "firefox";
        exec = "${pkgs.firefox}/bin/firefox";
      };

      viewnior = {
        name = "viewnior";
        exec = "${pkgs.viewnior}/bin/viewnior";
      };
    };

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

    configFile."mimeapps.list".force = true;
  };

  services = {
    arrpc.enable = true;

    gpg-agent = {
      enable = true;
      pinentry.package = pkgs.pinentry-gnome3;
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "24.05";
}
