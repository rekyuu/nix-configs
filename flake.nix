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
    ...
  } @ inputs: let
    inherit (self) outputs;
  in {
    overlays = import ./overlays { inherit inputs; };
    
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      ikuyo = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs outputs; };
        
        modules = [
          ./hosts/ikuyo/configuration.nix
          
          nixpkgs-xr.nixosModules.nixpkgs-xr
          # nur.modules.nixos.default

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

          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.rekyuu = import ./hosts/umiko/rekyuu.nix;
          }
        ];
      };

      fluorite = nixos-raspberrypi.lib.nixosSystemFull {
        specialArgs = { inherit inputs outputs; };

        modules = [
          ./hosts/fluorite/configuration.nix

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
