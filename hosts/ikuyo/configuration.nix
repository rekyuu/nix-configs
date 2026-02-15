{
  config,
  inputs,
  lib,
  pkgs,
  modulesPath,
  ...
}:
let
  logidConfig = pkgs.writeTextFile {
    name = "logid.cfg";
    text = builtins.readFile ./static/logid.cfg;
  };

  westonConfig = pkgs.writeTextFile {
    name = "weston.ini";
    text = builtins.readFile ./static/weston.ini;
  };
in {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.aagl.nixosModules.default
    ];

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
        configurationLimit = 4;
      };

      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernelModules = [ "kvm-amd" ];
    extraModulePackages = with pkgs.linuxKernel.packages.linux_zen; [ decklink ];

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ "amdgpu" "nct6775" "nfs" ];
    };

    kernelParams = [
      # power cycle fix
      "power_dpm_force_performance_level=high"
      # eth random shutdown fix
      "amd_pstate=active"
      "processor.max_cstate=9"
      "workqueue.power_efficient=1"
      "pcie_port_pm=off"
      "pcie_aspm.policy=performance"
    ];
  };

  powerManagement.cpuFreqGovernor = "performance";

  networking = {
    hostName = "ikuyo";

    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    interfaces.eno1.wakeOnLan.enable = true;

    firewall = {
      allowedTCPPorts = [ 22 6600 7000 7001 7100 ];
      allowedUDPPorts = [ 5353 6000 6001 7011 ];
      trustedInterfaces = [ "docker0" ];
    };
  };

  time = {
    hardwareClockInLocalTime = true;
    timeZone = "US/Mountain";
  };
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocales = [ "ja_JP.UTF-8/UTF-8" ];
    supportedLocales = [ "en_US.UTF-8/UTF-8" "ja_JP.UTF-8/UTF-8" ];

    extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_COLLATE = "en_US.UTF-8";
      LC_CTYPE = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MESSAGES = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    inputMethod = {
      enable = true;
      type = "fcitx5";

      fcitx5 = {
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-mozc
        ];

        waylandFrontend = true;
      };
    };
  };

  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/38902bdc-90ff-4de0-8f37-cb8ce304ff1b";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/6B5C-4E4B";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/games" = { 
      device = "/dev/disk/by-uuid/b733f944-f417-4a46-aaf6-523ad9e3c542";
      fsType = "ext4";
    };

    "/mnt/arctic" = { 
      device = "/dev/disk/by-uuid/ba48884f-bc76-4847-ad10-915920e13b82";
      fsType = "ext4";
    };

    "/mnt/rikka" = {
      device = "rikka-1.localdomain:/volume1/rikka";
      fsType = "nfs";
    };
  };

  swapDevices = [ ];

  hardware = {
    bluetooth = {
      enable = true;
      settings = {
        General = {
          ControllerMode = "bredr";
        };
      };
    };

    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    decklink.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;

      extraPackages = with pkgs; [
        rocmPackages.clr
        rocmPackages.clr.icd
      ];
    };

    steam-hardware.enable = true;
  };

  nix = {
    # distributedBuilds = true;

    # buildMachines = [
    #   {
    #     hostName = "fluorite.localdomain";
    #     system = "aarch64-linux";
    #     protocol = "ssh";
    #     sshUser = "rekyuu";
    #     sshKey = "/home/rekyuu/.ssh/id_ed25519";
    #     publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUVQSUZZY0NxVEl0WE9Db2EzQjBPTndvTzg5VDdkdGNqcndaNDZmUEFnVDYgcm9vdEByYXNwYmVycnlwaQo=";
    #     maxJobs = 3;
    #     speedFactor = 1;
    #     supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
    #     mandatoryFeatures = [ ];
    #   }
    # ];

    settings = {
      # builders-use-substitutes = true;
      
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      download-buffer-size = 536870912; # 512 MB

      # trusted-users = [ "rekyuu" ];

      substituters = [
        "https://cache.nixos.org?priority=10"
        "https://anyrun.cachix.org"
        "https://hyprland.cachix.org"
        "https://nix-community.cachix.org"
        "https://nix-gaming.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };  

  nixpkgs = {
    hostPlatform = lib.mkDefault "x86_64-linux";
    
    # overlays = [
    #   outputs.overlays.unstable-packages
    #   # Nautilus Gstreamer stuff
    #   (self: super: {
    #     gnome = super.gnome.overrideScope (gself: gsuper: {
    #       nautilus = gsuper.nautilus.overrideAttrs (nsuper: {
    #         buildInputs = nsuper.buildInputs ++ (with gst_all_1; [
    #           gst-plugins-good
    #           gst-plugins-bad
    #         ]);
    #       });
    #     });
    #   })
    # ];
    
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  fonts = {
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-color-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (callPackage ../../pkgs/scp-zh-fonts {}) # mahjong soul font
    ];

    fontconfig = {
      defaultFonts = {
        monospace = [
          "Cascadia Code"
          "Noto Sans Mono"
          "Noto Sans Mono CJK JP"
        ];

        sansSerif = [
          "Noto Sans"
          "Noto Sans CJK JP"
        ];

        serif = [
          "Noto Serif"
          "Noto Serif CJK JP"
        ];
      };
    };
  };

  environment = {
    pathsToLink = [ "share/thumbnailers" ];

    systemPackages = with pkgs; [
      bash
      blackmagic-desktop-video
      ffmpeg-headless
      ffmpegthumbnailer
      gdk-pixbuf
      git
      libsecret
      logiops_0_2_3
      tree
      uxplay
      vim
      weston
      wget
      zsh
    ];

    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      SYSTEMD_EDITOR = "vim";
      # AMD_VULKAN_ICD = "RADV"; # gamescope seems to freak out if RADV is set, so it'll be unset by default
      VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";

      GTK_IM_MODULE = "fcitx";
      QT_IM_MODULE = "fcitx";
      SDL_IM_MODULE = "fcitx";
      XMODIFIERS = "@im=fcitx";
    };
  };

  programs = {
    adb.enable = true;

    appimage = {
      enable = true;
      binfmt = true;
    };

    cdemu.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    zsh.enable = true;

    # Has to be done here because of hosts file shenanigans, probably
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;
    sleepy-launcher.enable = true;
    wavey-launcher.enable = true;
  };
  
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;

      publish = {
        enable = true;
        addresses = true;
        workstation = true;
        userServices = true;
        domain = true;
      };
    };

    blueman.enable = true;

    displayManager = {
      # Add pkgs.swayfx if you're using it here. they have the same binary name for some reason
      sessionPackages = [ pkgs.sway ];
      defaultSession = "sway";

      sddm = {
        enable = true;
        autoNumlock = true;
        theme = "${(pkgs.callPackage ../../pkgs/reactionary-sddm-theme {})}/share/sddm/themes/reactionary";
        
        wayland = {
          enable = true;
          compositor = "weston";
          compositorCommand = "weston --config ${westonConfig}";
        };

        settings = {
          General = {
            GreeterEnvironment = "QT_WAYLAND_SHELL_INTEGRATION=fullscreen-shell-v1";
          };
        };
      };
    };
    
    # Make sure to use the Login collection as the default keyring
    gnome.gnome-keyring.enable = true;

    # For trash://
    gvfs.enable = true;

    monado = {
      enable = true;
      defaultRuntime = true;
      package = pkgs.monado;
    };
    
    openssh = {
      enable = true;
    };

    pipewire = {
      enable = true;
      
      wireplumber.enable = true;
      pulse.enable = true;
      jack.enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
    };

    printing = {
      enable = true;
      drivers = [ pkgs.brlaser ];
    };
    
    udev.extraRules = ''
      ${ builtins.readFile ./static/udev-rules/goxlr.rules }
      ${ builtins.readFile ./static/udev-rules/keychron-q6.rules }
      ${ builtins.readFile ./static/udev-rules/vhba.rules }
    '';

    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      displayManager.session = [ ];

      displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output "HDMI-A-0" --mode "2560x2880" --rate "60" --pos "0x0" 
        ${pkgs.xorg.xrandr}/bin/xrandr --output "DisplayPort-0" --mode "3440x1440" --rate "144" --pos "2560x1440" --primary --preferred
        ${pkgs.xorg.xrandr}/bin/xrandr --output "DisplayPort-1" --mode "2560x2880" --rate "60" --pos "6000x0"
        ${pkgs.xorg.xrandr}/bin/xrandr --output "DisplayPort-2" --prop --set non-desktop 1
      '';
    };
  };

  systemd = {
    tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    services = {
      logid = {
        wantedBy = [ "multi-user.target" ];
        description = "Logitech Configuration Daemon";
        startLimitIntervalSec = 0;
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.logiops_0_2_3}/bin/logid --config ${logidConfig}";
          User = "root";
          ExecReload = "/bin/kill -HUP $MAINPID";
          Restart = "on-failure";
        };
      };

      numLockOnTty = {
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          ExecStart = lib.mkForce (pkgs.writeShellScript "numLockOnTty" ''
            for tty in /dev/tty{1..6}; do
                ${pkgs.kbd}/bin/setleds -D +num < "$tty";
            done
          '');
        };
      };

      rtkit-daemon.serviceConfig.ExecStart = [
        ""
        "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
      ];
    };

    user.services = {
      monado.environment = {
        STEAMVR_LH_ENABLE = "1";
        XRT_COMPOSITOR_COMPUTE = "1";
      };

      polkit-gnome-authentication-agent-1 = {
        description = "polkit-gnome-authentication-agent-1";
        wantedBy = [ "graphical-session.target" ];
        wants = [ "graphical-session.target" ];
        after = [ "graphical-session.target" ];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };
    };
  };

  security = {
    pam = {
      loginLimits = [
        { domain = "@users"; item = "rtprio"; type = "-"; value = 1; }
      ];
      
      services = {
        login.enableGnomeKeyring = true;
        sddm.enableGnomeKeyring = true;
        hyprlock = {};
      };
    };

    polkit = {
      enable = true;

      extraConfig = ''
        polkit.addRule(function(action, subject) {
          if (subject.isInGroup("wheel") && action.id == "org.freedesktop.policykit.exec")
          {
            return polkit.Result.YES;
          }
        })
      '';
    };

    # FIXME: this
    sudo.wheelNeedsPassword = false;
  };

  users.users.rekyuu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "realtime" "docker" "adbusers" ];
    shell = pkgs.zsh;
  };

  virtualisation = {
    docker.enable = true;
    waydroid.enable = true;
  };

  xdg.portal = {
    enable = true;
    wlr.enable = true;
    xdgOpenUsePortal = true;

    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

    config = {
      common = {
        default = [ "gtk" ];

        "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
        "org.freedesktop.impl.portal.OpenURI" = [ "gtk" ];
      };
    };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

