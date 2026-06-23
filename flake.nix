# Flake подключает ветку nixos-unstable (требование для Noctalia v5), 
# репозиторий Disko и официальный репозиторий Noctalia v5. Также 
# настраивается бинарный кэш Cachix, чтобы система скачивала уже 
# собранную оболочку вместо её долгой компиляции внутри виртуальной машины

{
  description = "NixOS + Noctalia v5 + Niri Configuration for Hyper-V";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia"; # Репозиторий v5 по умолчанию
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, disko, noctalia, ... }: {
    nixosConfigurations.hyperv-nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./disko-config.nix
        ./hardware-configuration.nix
        ./configuration.nix
        
        # Подключаем официальный NixOS-модуль оболочки
        noctalia.nixosModules.default
      ];
    };
  };
}
