# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, ... }:

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 4;
      efi.canTouchEfiVariables = true;
    };

    initrd = {
      availableKernelModules = [ "nvme" "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
      kernelModules = [ ];
    };

    kernelModules = [ "kvm-amd" ];
    extraModulePackages = [ ];
  };

  networking = {
    hostName = "ikuyo";

    networkmanager.enable = true;
    useDHCP = lib.mkDefault true;

    firewall = {
      allowedTCPPorts = [ 22 ];
      allowedUDPPorts = [ ];
    };
  };

  time.timeZone = "America/Boise";

  i18n = {
    defaultLocale = "en_US.UTF-8";
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

  hardware = {
    cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
    opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;
      extraPackages = with pkgs; [
        amdvlk
        rocmPackages.clr.icd
        rocmPackages.clr
      ];
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
    ];
  };

  security = {
    # FIXME: this
    sudo.wheelNeedsPassword = false;
    polkit.enable = true;
  };

  nix = {
    settings = {
      experimental-features = "nix-command flakes";
      auto-optimise-store = true;
      substituters = [
        "https://hyprland.cachix.org"
      ];
      trusted-public-keys = [
        "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      ];
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

  environment.systemPackages = with pkgs; [
    git
    tree
    vim
    wget
    zsh
  ];

  programs = {
    mtr.enable = true;
    zsh.enable = true;

    gnupg.agent = {
      enable = true;
      enableSSHSupport = true;
    };
  };
  
  services = {
    openssh = {
      enable = true;
    };

    pipewire = {
      enable = true;
      pulse.enable = true;
    };

    udev.extraRules = ''
      # GoXLR
      SUBSYSTEM=="usb", ATTR{idVendor}=="1220", ATTR{idProduct}=="8fe4", TAG+="uaccess"
      SUBSYSTEM=="usb", ATTR{idVendor}=="1220", ATTR{idProduct}=="8fe0", TAG+="uaccess"
    '';
  };

  users.users.rekyuu = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "24.05"; # Did you read the comment?

}

