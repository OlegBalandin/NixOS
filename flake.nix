# flake.nix
# Точка входа: nixpkgs + home-manager + niri-flake
# nixos-rebuild switch --flake .#nixos

{
  description = "NixOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, niri-flake, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./configuration.nix
        home-manager.nixosModules.home-manager
        niri-flake.nixosModules.niri
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.user = import ./home.nix;
          # niri-flake через home-manager
          home-manager.extraSpecialArgs = { inherit inputs; };
        }
        # Кэш niri-flake для ускорения сборки
        { nix.settings.trusted-substituters = [ "https://niri.cachix.org" ];
          nix.settings.trusted-public-keys = [
            "niri.cachix.org-1:Wv0OmO7PsuocRKZFDoqF8sfQcaXWt5UvJzE7b1e0i8E="
          ];
        }
      ];
      specialArgs = { inherit inputs; };
    };
  };
}
