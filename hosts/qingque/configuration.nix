{
  config,
  lib, 
  pkgs, 
  modulesPath, 
  ... 
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    loader = {
      # Use the extlinux boot loader. (NixOS wants to enable GRUB by default)
      grub.enable = false;

      # Enables the generation of /boot/extlinux/extlinux.conf
      generic-extlinux-compatible.enable = true;
    };

    kernelParams = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];

    initrd = {
      availableKernelModules = [ "xhci_pci" "usbhid" ];
      kernelModules = [ ];
    };
  };

  networking = {
    hostName = "qingque";
    
    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    firewall = {
      allowedTCPPorts = [ 
        22   # ssh
        2379 # k3s, etcd clients
        2380 # k3s, etcd peers
        6443 # k3s
      ];

      allowedUDPPorts = [ 
        8472 # k3s, flannel
      ];

      trustedInterfaces = [ ];
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
      device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
      options = [ "noatime" ];
    };
  };

  swapDevices = [ ];

  hardware = { };

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
        "https://nixos-raspberrypi.cachix.org"
      ];

      trusted-public-keys = [
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
      ];
    };

    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 30d";
    };
  };

  nixpkgs = {
    hostPlatform = lib.mkDefault "aarch64-linux";
    
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

  sops = {
    defaultSopsFile = ../../secrets/common.yaml;
    age.keyFile = "/home/rekyuu/.config/sops/age/keys.txt";

    secrets = {
      k3s-token = {};
    };
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  users.users = {
    rekyuu = {
      isNormalUser = true;
      extraGroups = [ "wheel" "docker" ];
      shell = pkgs.zsh;
    };
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "26.05"; # Did you read the comment?
}