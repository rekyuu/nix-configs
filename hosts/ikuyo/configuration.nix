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
      allowedTCPPorts = [ 22 7000 7001 7100 ];
      allowedUDPPorts = [ 5353 6000 6001 7011 ];
    };
  };

  time.timeZone = "US/Mountain";
  
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = ["en_US.UTF-8/UTF-8"];

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

    "/mnt/arch" = { 
      device = "/dev/disk/by-uuid/d7dd0099-728d-437f-8972-90d044d606ac";
      fsType = "ext4";
    };

    "/mnt/arch/boot" = { 
      device = "/dev/disk/by-uuid/9DED-37F5";
      fsType = "vfat";
      options = [ "fmask=0077" "dmask=0077" ];
    };

    "/mnt/games" = { 
      device = "/dev/disk/by-uuid/ba48884f-bc76-4847-ad10-915920e13b82";
      fsType = "ext4";
    };

    "/mnt/rikka" = {
      device = "192.168.0.16:/volume1/rikka";
      fsType = "nfs";
    };
  };

  swapDevices = [ ];

  # gamescope seems to freak out if both amdvlk and radv are available, so we'll just disable amdvlk for now
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

    decklink.enable = true;

    opengl = {
      enable = true;

      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [
        # amdvlk
        rocmPackages.clr
        rocmPackages.clr.icd
      ];

      extraPackages32 = with pkgs; [
        # driversi686Linux.amdvlk
      ];
    };
  };

  environment.variables = {
    EDITOR = "vim";
    VISUAL = "vim";
    SYSTEMD_EDITOR = "vim";
    # AMD_VULKAN_ICD = "RADV";
    # VK_ICD_FILENAMES = "/run/opengl-driver/share/vulkan/icd.d/radeon_icd.x86_64.json";
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;

      substituters = [
        "https://ezkea.cachix.org"
        "https://hyprland.cachix.org"
      ];

      trusted-public-keys = [
        "ezkea.cachix.org-1:ioBmUbJTZIKsHmWWXPe1FSFbeVe+afhfgqgTSNd34eI="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
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
    
    overlays = [ ];
    
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  fonts = {
    packages = with pkgs; [
      cascadia-code
      noto-fonts
      noto-fonts-emoji
      noto-fonts-monochrome-emoji
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      (callPackage ../../pkgs/scp-zh-fonts {}) # mahjong soul font
    ];
  };

  environment.systemPackages = with pkgs; [
    bash
    blackmagic-desktop-video
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

  programs = {
    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };

    mtr.enable = true;
    zsh.enable = true;

    # Has to be done here because of hosts file shenanigans, probably
    anime-game-launcher.enable = true;
    honkers-railway-launcher.enable = true;
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

    displayManager = {
      # Add pkgs.swayfx if you're using it here. they have the same binary name for some reason
      sessionPackages = [ pkgs.hyprland pkgs.sway ];
      defaultSession = "hyprland";

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
    
    udev.extraRules = ''      
      ${ builtins.readFile ./static/udev-rules/goxlr.rules }
    '';

    xserver = {
      enable = true;
      videoDrivers = [ "amdgpu" ];

      displayManager.session = [
        {
          name = "bspwm";
          manage = "desktop";
          start = "exec ${pkgs.bspwm}/bin/bspwm";
        }
        {
          name = "i3";
          manage = "desktop";
          start = "exec ${pkgs.i3}/bin/i3";
        }
      ];

      displayManager.setupCommands = ''
        ${pkgs.xorg.xrandr}/bin/xrandr --output "HDMI-A-0" --mode "2560x2880" --rate "60" --pos "0x0" 
        ${pkgs.xorg.xrandr}/bin/xrandr --output "DisplayPort-0" --mode "3440x1440" --rate "144" --pos "2560x1440" --primary --preferred
        ${pkgs.xorg.xrandr}/bin/xrandr --output "DisplayPort-1" --mode "2560x2880" --rate "60" --pos "6000x0"
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
    extraGroups = [ "wheel" "realtime" ];
    shell = pkgs.zsh;
  };

  xdg.portal = {
    enable = true;

    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];

    configPackages = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];

    config.common.default = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-hyprland
      xdg-desktop-portal-wlr
    ];
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?
}

