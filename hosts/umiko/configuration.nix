{ 
  config,
  lib,
  pkgs, 
  modulesPath, 
  ... 
}: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # Use the systemd-boot EFI boot loader.
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

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [ "xhci_pci" ];
      kernelModules = [ "amdgpu" "nfs" ];
    };

    binfmt.emulatedSystems = [ "aarch64-linux" ];
  };

  networking = {
    hostName = "umiko";

    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    interfaces.enp4s0.wakeOnLan.enable = true;

    firewall = {
      allowedTCPPorts = [ 
        22   # ssh
        2283 # immich
        2379 # k3s, etcd clients
        2380 # k3s, etcd peers
        6443 # k3s
        8096 # jellyfin
        9999 # stashapp
        13378 # audiobookshelf
      ];

      allowedUDPPorts = [ 
        7359 # jellyfin, client discovery
        8472 # k3s, flannel
      ];

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
  };

  fileSystems = {
    "/" = { 
      device = "/dev/disk/by-uuid/a911fe90-f453-4236-bcfc-d4f2b69aa5a7";
      fsType = "ext4";
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/4687-4D2C";
      fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    "/mnt/alpha" = {
      device = "/dev/disk/by-uuid/78a4ff36-b4bf-4b99-afc2-d31e5e66dfdd";
      fsType = "ext4";
    };

    "/mnt/beta" = {
      device = "/dev/disk/by-uuid/0beb5ab5-d502-43fc-bb35-a8d562be065a";
      fsType = "ext4";
    };

    "/mnt/rikka" = {
      device = "rikka-1.localdomain:/volume1/rikka";
      fsType = "nfs";
    };
  };

  swapDevices = [ ];
  
  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      download-buffer-size = 536870912; # 512 MB

      trusted-users = [ "rekyuu" ];

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

    overlays = [
      # outputs.overlays.unstable-packages
    ];
    
    config = {
      allowUnfree = true;
      allowUnfreePredicate = _: true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      age
      bash
      git
      sops
      tree
      vim
      wget
      zsh
    ];

    variables = {
      EDITOR = "vim";
      VISUAL = "vim";
      SYSTEMD_EDITOR = "vim";
    };
  };

  programs = {
    mtr.enable = true;
    zsh.enable = true;
  };

  services = {
    gvfs.enable = true;

    k3s = {
      enable = true;
      role = "server";
      clusterInit = true;
      tokenFile = config.sops.secrets.k3s-token.path;
    };
    
    openssh = {
      enable = true;

      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        ChallengeResponseAuthentication = false;
        MaxAuthTries = 2;
        AllowTcpForwarding = false;
        X11Forwarding = false;
        AllowAgentForwarding = false;
      };
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.keyFile = "/home/rekyuu/.config/sops/age/keys.txt";

    secrets = {
      k3s-token = {};
    };
  };

  users.users.rekyuu = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  virtualisation = {
    docker.enable = true;
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?
}