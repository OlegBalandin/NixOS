# configuration.nix
{ config, pkgs, inputs, username, ... }:

{
  # --- Базовые настройки ---
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # --- Hyper-V специфичные настройки ---
  virtualisation.hypervGuest.enable = true;
  boot.initrd.kernelModules = [ "hv_vmbus" "hv_storvsc" ];
  boot.kernelParams = [ "video=hyperv_fb:1920x1080" ];

  # --- Локаль и время ---
  time.timeZone = "Europe/Moscow";
  i18n.defaultLocale = "ru_RU.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ru_RU.UTF-8";
    LC_IDENTIFICATION = "ru_RU.UTF-8";
    LC_MEASUREMENT = "ru_RU.UTF-8";
    LC_MONETARY = "ru_RU.UTF-8";
    LC_NAME = "ru_RU.UTF-8";
    LC_NUMERIC = "ru_RU.UTF-8";
    LC_PAPER = "ru_RU.UTF-8";
    LC_TELEPHONE = "ru_RU.UTF-8";
    LC_TIME = "ru_RU.UTF-8";
  };

  # --- Пользователь ---
  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "input" ];
    initialPassword = "changeme";
  };

  security.sudo.wheelNeedsPassword = false; # уберите после первичной настройки

  # --- Nix ---
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      "https://cache.nixos.org"
      "https://niri.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
    ];
  };

  # --- Графика и Wayland ---
  hardware.graphics.enable = true;

  # Niri
  programs.niri.enable = true;

  # XWayland для X11-приложений
  programs.xwayland.enable = true;

  # --- Сессия: greetd автологин в niri ---
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${config.programs.niri.package}/bin/niri-session";
        user = username;
      };
    };
  };
  systemd.user.services.niri.enableDefaultPath = false;

  # --- Сопутствующие сервисы Wayland ---
  security.polkit.enable = true;
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.swaylock = {};

  # --- Desktop portal ---
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
    ];
  };

  # --- Шрифты ---
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # --- Системные пакеты ---
  environment.systemPackages = with pkgs; [
    git
    helix
    alacritty
    fuzzel            # launcher (Super+D по умолчанию)
    waybar            # панель
    swaylock          # блокировка экрана
    swayidle          # управление idle
    mako              # уведомления
    wl-clipboard      # буфер обмена
    grim              # скриншоты
    slurp             # выделение области
    brightnessctl
    pavucontrol
    rustup
    gcc
    pkg-config
    openssl
    curl
    wget
    btop
  ];

  # --- Звук ---
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # --- SSH (на случай удалённой настройки) ---
  services.openssh.enable = true;

  # --- zRAM (полезно в VM с ограниченной памятью) ---
  zramSwap = {
    enable = true;
    priority = 100;
    memoryPercent = 100;
  };

  # --- Автоочистка старых поколений ---
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  system.stateVersion = "25.05";
}
