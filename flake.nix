{
  description = "rekyuu's nix configs";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixpkgs-b618ed69.url = "github:nixos/nixpkgs/b618ed69e325363246049979bec5a7a13ee31e74"; # for decklink

    # NUR
    nur.url = "github:nix-community/NUR";
    nur.inputs.nixpkgs.follows = "nixpkgs";

    # Home Manager
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Anime games
    aagl.url = "github:ezKEa/aagl-gtk-on-nix/release-25.05";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
    nur,
    home-manager,
    aagl,
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
          nur.modules.nixos.default
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.extraSpecialArgs = { inherit inputs; };
            home-manager.users.rekyuu = import ./home/rekyuu.nix;
            home-manager.sharedModules = [ nur.modules.homeManager.default ];
          }
        ];
      };
    };
  };
}
