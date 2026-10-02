# home.nix
# Пользовательское окружение: niri, helix, git, alacritty, zsh, waybar

{ pkgs, inputs, ... }:

{
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "24.05";

  # ── Пользовательские пакеты ───────────────────────────────
  home.packages = with pkgs; [
    zsh
    fish
    zsh-syntax-highlighting
    zsh-autosuggestions
    helix
    alacritty
    git
    rustup
    gcc
    pkg-config
    openssl
    waybar
    mako
    fuzzel
    swaylock
    swayidle
    wl-clipboard
    fzf
    fd
    ripgrep
  ];

  # ── ZSH ──────────────────────────────────────────────────
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    history.size = 10000;
    history.path = "$HOME/.zsh_history";

    shellAliases = {
      ll = "ls -lah";
      la = "ls -a";
      ".." = "cd ..";
      "..." = "cd ../..";
      gs = "git status";
      gd = "git diff";
      gl = "git log --oneline --graph";
      rebuild = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      update = "sudo nixos-rebuild switch --flake /etc/nixos#nixos";
      clean = "sudo nix-collect-garbage --delete-older-than 7d";
    };

    initContent = ''
      # Промпт
      autoload -Uz vcs_info
      precmd_vcs_info() { vcs_info }
      precmd_functions+=(precmd_vcs_info)
      setopt PROMPT_SUBST
      zstyle ':vcs_info:git*' formats ' (%F{yellow}%b%f)'
      PROMPT='%F{blue}%n@%m%f:%F{green}%~%f''${vcs_info_msg_0_} %# '

      # fzf интеграция
      if command -v fzf-share &>/dev/null; then
        source "$(fzf-share)/key-bindings.zsh"
        source "$(fzf-share)/completion.zsh"
      fi
    '';
  };

  # ── Git ──────────────────────────────────────────────────
  programs.git = {
    enable = true;
    userName = "user";
    userEmail = "user@localhost";
    aliases = {
      st = "status";
      co = "checkout";
      br = "branch";
      ci = "commit";
      lg = "log --oneline --graph --all";
    };
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
  };

  # ── Helix ────────────────────────────────────────────────
  programs.helix = {
    enable = true;
    defaultEditor = true;
    settings = {
      theme = "gruvbox";
      editor = {
        line-number = "relative";
        lsp.display-messages = true;
        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };
        indent-guides.render = true;
        auto-pairs = true;
        auto-format = true;
      };
      keys.normal = {
        space.space = "file_picker";
        space.w = ":w";
        space.q = ":q";
      };
    };
    languages = {
      language = [{
        name = "rust";
        auto-format = true;
        formatter.command = "rustfmt";
      }];
    };
  };

  # ── Alacritty ────────────────────────────────────────────
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        decorations = "None";
        opacity = 0.95;
        padding = { x = 6; y = 6; };
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 12.0;
      };
      colors = {
        primary = {
          background = "#282828";
          foreground = "#ebdbb2";
        };
        normal = {
          black   = "#282828";
          red     = "#cc241d";
          green   = "#98971a";
          yellow  = "#d79921";
          blue    = "#458588";
          magenta = "#b16286";
          cyan    = "#689d6a";
          white   = "#a89984";
        };
        bright = {
          black   = "#928374";
          red     = "#fb4934";
          green   = "#b8bb26";
          yellow  = "#fabd2f";
          blue    = "#83a598";
          magenta = "#d3869b";
          cyan    = "#8ec07c";
          white   = "#ebdbb2";
        };
      };
    };
  };

  # ── Niri (Wayland-композитор) ────────────────────────────
  programs.niri = {
    settings = {
      input = {
        keyboard = {
          xkb.layout = "us,ru";
          xkb.options = "grp:win_space_toggle";
        };
        touchpad.natural-scroll = true;
      };

      layout = {
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#458588";
          inactive.color = "#282828";
        };
        gaps = 8;
      };

      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
      ];

      bindings = {
        "Mod+Return"       = { action.spawn = [ "alacritty" ]; };
        "Mod+D"            = { action.spawn = [ "fuzzel" ]; };
        "Mod+Q"            = { action.close-window = { }; };
        "Mod+Shift+E"      = { action.quit = { }; };
        "Mod+L"            = { action.spawn = [ "swaylock" ]; };
        "Mod+Space"        = { action.switch-layout = "next"; };

        "Mod+Left"         = { action.focus-column-left = { }; };
        "Mod+Right"        = { action.focus-column-right = { }; };
        "Mod+Up"           = { action.focus-window-up = { }; };
        "Mod+Down"         = { action.focus-window-down = { }; };

        "Mod+Shift+Left"   = { action.move-column-left = { }; };
        "Mod+Shift+Right"  = { action.move-column-right = { }; };
        "Mod+Shift+Up"     = { action.move-window-up = { }; };
        "Mod+Shift+Down"   = { action.move-window-down = { }; };

        "Mod+1" = { action.focus-workspace = 1; };
        "Mod+2" = { action.focus-workspace = 2; };
        "Mod+3" = { action.focus-workspace = 3; };
        "Mod+4" = { action.focus-workspace = 4; };
        "Mod+5" = { action.focus-workspace = 5; };
        "Mod+6" = { action.focus-workspace = 6; };
        "Mod+7" = { action.focus-workspace = 7; };
        "Mod+8" = { action.focus-workspace = 8; };
        "Mod+9" = { action.focus-workspace = 9; };
      };
    };
  };

  # ── Waybar ───────────────────────────────────────────────
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 28;
      modules-left = [ "niri/workspaces" ];
      modules-center = [ "clock" ];
      modules-right = [ "pulseaudio" "network" "battery" "tray" ];

      clock.format = "{:%H:%M %d.%m}";

      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "MUTED";
        format-icons = { default = [ "VOL" ]; };
      };

      network = {
        format-wifi = "{essid} {signalStrength}%";
        format-disconnected = "DISCONNECTED";
      };

      battery = {
        format = "{capacity}% BAT";
      };
    }];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background-color: #282828;
        color: #ebdbb2;
      }
      .modules-right {
        margin-right: 8px;
      }
      .modules-left {
        margin-left: 8px;
      }
    '';
  };

  # ── Mako (уведомления) ───────────────────────────────────
  services.mako = {
    enable = true;
    settings = {
      font = "JetBrainsMono Nerd Font 12";
      background-color = "#282828";
      text-color = "#ebdbb2";
      border-color = "#458588";
      border-radius = 5;
      default-timeout = 5000;
    };
  };

  # ── Swaylock ─────────────────────────────────────────────
  programs.swaylock = {
    enable = true;
    settings = {
      color = "282828ff";
      font = "JetBrainsMono Nerd Font";
      indicator-radius = 100;
    };
  };
}
