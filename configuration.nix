# Системная конфигурация
# Здесь включаются необходимые гостевые службы Hyper-V, 
# службы ядра для работы Noctalia v5, оконный менеджер Niri
# и создается ваш пользователь

{ config, pkgs, ... }:

{
  # Включение интеграции с Hyper-V (сеть, мышь, буфер обмена)
  virtualisation.hypervGuest.enable = true;

  # Настройки загрузчика (Systemd-boot для UEFI поколения 2)
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "hyperv-nixos";
  
  # Необходимые сетевые и системные службы для Noctalia v5
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable = true;

  # Включаем оконный менеджер Niri
  programs.niri.enable = true;

  # Включаем и настраиваем Noctalia v5 глобально
  services.noctalia = {
    enable = true;
    # Дополнительные глобальные настройки Noctalia v5 можно описывать здесь
  };

  # Создание пользователя (замените "username" на ваше имя)
  users.users.username = {
    isNormalUser = true;
    description = "Пользователь Noctalia";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    packages = with pkgs; [
      # Базовый софт, который пригодится в Wayland/Niri
      alacritty # Эмулятор терминала
      firefox   # Браузер
    ];
  };

  # Разрешаем несвободные пакеты
  nixpkgs.config.allowUnfree = true;

  # Настройка бинарного кэша для Noctalia, чтобы ускорить установку
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [ "https://cache.nixos.org" "https://cachix.org" ];
    trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "noctalia.cachix.org-1:YOUR_NOCTALIA_CACHIX_KEY_IF_NEEDED" ]; # Кэш подтянется автоматически при сборке Flake
  };

  system.stateVersion = "26.05"; # Оставьте версию согласно вашему ISO
}
