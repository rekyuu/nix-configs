{
  description = "rekyuu's nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    # nixpkgs-b618ed69.url = "github:nixos/nixpkgs/b618ed69e325363246049979bec5a7a13ee31e74"; # for decklink

    # nixpkgs-xr
    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";

    # NUR
    # Disabled since this causes the obnoxious error below
    # You have set either `nixpkgs.config` or `nixpkgs.overlays` while using `home-manager.useGlobalPkgs`.
    # This will soon not be possible. Please remove all `nixpkgs` options when using `home-manager.useGlobalPkgs`.
    # https://github.com/nix-community/NUR/issues/877 
    # nur.url = "github:nix-community/NUR";
    # nur.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Anime games
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-25.11";
    aagl.inputs.nixpkgs.follows = "nixpkgs";

    # Raspberry Pi
    nixos-raspberrypi.url = "github:nvmd/nixos-raspberrypi/main";
    nixos-raspberrypi.inputs.nixpkgs.follows = "nixpkgs";

    # MacOS
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    # sops
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org?priority=10"
      "https://anyrun.cachix.org"
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixos-raspberrypi.cachix.org"
    ];

    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "anyrun.cachix.org-1:pqBobmOjI7nKlsUMV25u9QHa9btJK65/C8vnO3p346s="
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixos-raspberrypi.cachix.org-1:4iMO9LXa8BqhU+Rpg6LQKiGa2lsNh/j2oiYLNOQ5sPI="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-xr,
    # nur,
    home-manager,
    aagl,
    nixos-raspberrypi,
    nix-darwin,
    sops-nix,
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays { inherit inputs; };
    
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild [switch/boot] --sudo --flake .#hostname [--build-target hostname]'
    nixosConfigurations = {
      ikuyo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        
        modules = [
          ./hosts/ikuyo/configuration.nix
          
          nixpkgs-xr.nixosModules.nixpkgs-xr
          # nur.modules.nixos.default
          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.rekyuu = import ./hosts/ikuyo/rekyuu.nix;
            # home-manager.sharedModules = [ nur.modules.homeManager.default ];
          }
        ];
      };

      umiko = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/umiko/configuration.nix
          
          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.rekyuu = import ./hosts/umiko/rekyuu.nix;
          }
        ];
      };

      fluorite = nixos-raspberrypi.lib.nixosSystem {
        specialArgs = inputs;

        modules = [
          # https://github.com/nvmd/nixos-raspberrypi/issues/113#issuecomment-3698140050
          ({ lib, ... }: let
            renamePath = nixpkgs.outPath + "/nixos/modules/rename.nix";
            renameModule = import renamePath { inherit lib; };

            moduleFilter = module:
              lib.attrByPath ["options" "boot" "loader" "raspberryPi"] null
              (module {
                config = null;
                options = null;
              }) == null;
          in {
            disabledModules = [ renamePath ];
            imports = builtins.filter moduleFilter renameModule.imports;
          })

          {
            imports = with nixos-raspberrypi.nixosModules; [
              raspberry-pi-5.base
              raspberry-pi-5.page-size-16k
              raspberry-pi-5.display-vc4
              raspberry-pi-5.bluetooth
            ];
          }

          ./hosts/fluorite/configuration.nix
          
          sops-nix.nixosModules.sops

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.rekyuu = import ./hosts/fluorite/rekyuu.nix;
          }
        ];
      };
    };

    darwinConfigurations = {
      vivlos = nix-darwin.lib.darwinSystem {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/vivlos/configuration.nix

          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.rekyuu = import ./hosts/vivlos/rekyuu.nix;
          }
        ];
      };
    };
  };
}
