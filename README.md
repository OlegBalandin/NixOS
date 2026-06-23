# NixOS, Nix, Noctalia

Репозитарий по ОС NixOS, языку Nix для её пакетного менеджера и проекта Noctalia с красивым минималистичным окружением на основе тайлинга и quickshell   

## Операционная система NixOS
[Nix Ref](nixos.org/manual/nixos)

### Установка NixOS
``` bash
# 1. Перейдите в режим суперпользователя и настройте окружение
sudo su
mkdir -p /tmp/nixos-config
cd /tmp/nixos-config

# 2. Сгенерируйте аппаратную конфигурацию (hardware-configuration.nix)
nixos-generate-config --no-filesystems --dir
# (Флаг --no-filesystems критически важен, чтобы конфигурация дисков не дублировалась с файлом Disko)

# 3. Скопировать файлы конфигурации disko-config.nix, flake.nix и configuration.nix из [репозитори GitHub](https://github.com/OlegBalandin/Nix) в текущую директорию /tmp/nixos-config/ 
git clone https://github.com/OlegBalandin/Nix .

# 4. Создайте файлы конфигурации disko-config.nix для disko и запустите разметку диска через Disko
nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./disko-config.nix
# Эта команда автоматически сотрет диск виртуальной машины, создаст разделы, Btrfs-субтомы и смонтирует их в папку /mnt

# 5. Перенесите конфигурацию на примонтированный диск disko-config.nix, flake.nix и configuration.nix из /tmp/nixos-config/
mkdir -p /mnt/etc/nixos
cp -r * /mnt/etc/nixos/

# 6. Запустите установку системы из Flake
nixos-install --flake /mnt/etc/nixos/#hyperv-nixos

# 7. Задайте пароль пользователю и перезагрузитесь
nixos-enter -- passwd username
reboot

# 8. При первом входе в систему выберите сессию Niri в диспетчере входа. Композитор запустится, а поверх него автоматически развернется системная оболочка Noctalia v5 
```

## Язык Nix
[Nix Ref](nixos.org/manual/nix)
[Nix](./nix.md)

## Noctalia, тайлинг и Quickshell
Noctalia — это минималистичное окружение на базе тайлингового WM и Noctalia Shell (построено поверх Quickshell)

### Настройка конфигурации Noctalia v5
