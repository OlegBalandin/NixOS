# configuration.nix
# Системные настройки: Hyper-V, загрузчик, swap, zRAM, пакеты, greetd, звук

{ config, pkgs, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.niri-flake.nixosModules.niri
  ];

  # ── Hyper-V ──────────────────────────────────────────────
  virtualisation.hypervGuest.enable = true;
  boot.kernelParams = [ "video=hyperv_fb:1920x1080" ];
  boot.initrd.kernelModules = [ "hv_vmbus" "hv_storvsc" "hv_blkvsc" ];

  # ── Загрузчик (systemd-boot для UEFI) ─────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── zRAM (сжатие памяти, уменьшает риск OOM) ──────────────
  boot.zramSwap.enable = true;
  boot.zramSwap.size = "25";

  # ── Swap-раздел ───────────────────────────────────────────
  # Замените UUID на реальный — узнайте через: blkid /dev/sda3
  boot.swapDevices = [
    {
      device = "/dev/disk/by-uuid/sda3";
      priority = 10;
    }
  ];

  # ── Лимиты ядра для снижения риска OOM при сборке ─────────
  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.overcommit_memory" = 1;
  };

  # ── Сеть ─────────────────────────────────────────────────
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ── Локаль и часовой пояс ────────────────────────────────
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

  # ── Шрифты ───────────────────────────────────────────────
  fonts.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
  ];

  # ── Пользователь ─────────────────────────────────────────
  users.users.user = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "video" "audio" ];
    initialPassword = "changeme";
    shell = pkgs.zsh;
  };

  # ── Системные пакеты ──────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Shell
    zsh
    fish
    zsh-syntax-highlighting
    zsh-autosuggestions

    # Редактор и терминал
    helix
    alacritty

    # Git
    git

    # Rust
    rustup
    gcc
    pkg-config
    openssl

    # Утилиты
    wget
    curl
    htop
    btop
    fd
    ripgrep
    fzf
    tree
    unzip
    parted

    # Wayland-окружение
    waybar
    mako
    fuzzel
    swaylock
    swayidle
    wl-clipboard
    brightnessctl
    pamixer

    # Звук
    pulseaudio
  ];

  # ── Niri (Wayland-композитор) ─────────────────────────────
  programs.niri.enable = true;

  # ── Greetd (автологин в niri) ─────────────────────────────
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.niri}/bin/niri-session";
        user = "user";
      };
    };
  };

  # ── Звук (PipeWire) ──────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ── XDG-порталы (для Wayland) ────────────────────────────
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
  };

  # ── ZSH как системный shell ──────────────────────────────
  programs.zsh.enable = true;
  programs.fish.enable = true;

  # ── Отключаем firewall (для простоты в VM) ────────────────
  networking.firewall.enable = false;

  # ── Автоочистка старых поколений ─────────────────────────
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 14d";
  };

  # ── Лимиты сборки Nix (снижают риск OOM) ──────────────────
  nix.settings = {
    max-jobs = 2;
    cores = 2;
    auto-optimise-store = true;
  };

  # ── Версия системы ───────────────────────────────────────
  system.stateVersion = "24.05";
}
