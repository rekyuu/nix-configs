{
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
    ./applications/btop.nix
    ./applications/goxlr.nix
    ./applications/houdini.nix
    ./applications/hyprlock.nix
    ./applications/hyprpaper.nix
    ./applications/jellyfin-rpc.nix
    ./applications/kitty.nix
    ./applications/mpd.nix
    ./applications/mpv.nix
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

  dconf.settings = {
    "org/gtk/settings/file-chooser" = {
      sort-directories-first = true;
    };
  };

  home.packages = with pkgs; [
    adwaita-icon-theme
    anki
    archipelago
    audacity
    baobab
    bc
    (unstable.blender-hip.withPackages (python-pkgs: [
      python-pkgs.flatbuffers
    ]))
    bottles
    bruno
    cantata
    comma
    davinci-resolve
    dconf
    direnv
    easytag
    efibootmgr
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
    gnome-sound-recorder
    godotPackages_4_3.godot
    godotPackages_4_3.godot-mono
    godotPackages_4_3.export-template
    godotPackages_4_3.export-template-mono
    # godot
    # godot-mono
    # godotPackages.export-template
    # godotPackages.export-template-mono
    imagemagick
    iotop
    jellyfin-media-player
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
    mkvtoolnix
    nil
    nix-init
    nomacs
    obsidian
    p7zip
    pavucontrol
    pomodoro-gtk
    prismlauncher # minecraft
    protontricks
    protonup-qt
    python3
    r2modman
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
    unrar
    vesktop
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
    wlx-overlay-s
    xivlauncher
    yt-dlp
    (buildEnv { name = "scripts"; paths = [ ./scripts ]; })
  ];

  programs = {
    bash.enable = true;

    git = {
      enable = true;
      lfs.enable = true;
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
        "application/x-blender" = [ "blender.desktop" ];
        "audio/basic" = [ "mpv.desktop" ];
        "audio/flac" = [ "mpv.desktop" ];
        "audio/mpeg" = [ "mpv.desktop" ];
        "audio/ogg" = [ "mpv.desktop" ];
        "audio/vorbis" = [ "mpv.desktop" ];
        "audio/wav" = [ "mpv.desktop" ];
        "audio/x-it" = [ "mpv.desktop" ];
        "audio/x-mpegurl" = [ "mpv.desktop" ];
        "image/gif" = [ "viewnior.desktop" ];
        "image/jpeg" = [ "viewnior.desktop" ];
        "image/png" = [ "viewnior.desktop" ];
        "image/tiff" = [ "viewnior.desktop" ];
        "image/webp" = [ "viewnior.desktop" ];
        "inode/directory" = [ "nautilus-folder-handler.desktop" ];
        "text/html" = [ "firefox.desktop" ];
        "text/plain" = [ "code.desktop" ];
        "video/mp4" = [ "mpv.desktop" ];
        "video/quicktime" = [ "mpv.desktop" ];
        "video/webm" = [ "mpv.desktop" ];
        "video/x-flv" = [ "mpv.desktop" ];
        "video/x-matroska" = [ "mpv.desktop" ];
        "video/x-msvideo" = [ "mpv.desktop" ];
        "video/x-ms-wmv" = [ "mpv.desktop" ];
        "x-scheme-handler/about" = [ "firefox.desktop" ];
        "x-scheme-handler/http" = [ "firefox.desktop" ];
        "x-scheme-handler/https" = [ "firefox.desktop" ];
        "x-scheme-handler/unknown" = [ "firefox.desktop" ];
      };
    };

    configFile."mimeapps.list".force = true;
  };

  services = {
    arrpc.enable = true;

    fluidsynth = {
      enable = true;
      soundService = "pipewire-pulse";
    };

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
