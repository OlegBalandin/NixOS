# home.nix
{ config, pkgs, ... }:

{
  home.username = "oleg";
  home.homeDirectory = "/home/oleg";
  home.stateVersion = "25.05";

  # --- Helix ---
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

  # --- Git ---
  programs.git = {
    enable = true;
    userName = "oleg";
    userEmail = "oleg@example.com";
    extraConfig = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # --- Alacritty ---
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = { x = 6; y = 6; };
        decorations = "none";
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        size = 12;
      };
      colors = {
        primary = {
          background = "#282828";
          foreground = "#ebdbb2";
        };
      };
    };
  };

  # --- Niri ---
  programs.niri = {
    enable = true;
    settings = {
      prefer-no-csd = true;
      environment = {
        NIXOS_OZONE_WL = "1";
      };
      input = {
        keyboard.xkb.layout = "us,ru";
        keyboard.xkb.options = "grp:win_space_toggle";
        touchpad = {
          enable = true;
          tap = true;
        };
      };
      layout = {
        gaps = 6;
        focus-ring = {
          enable = true;
          width = 2;
          active.color = "#fabd2f";
          inactive.color = "#504945";
        };
      };
      binds = {
        "Mod+Return".action.spawn = [ "alacritty" ];
        "Mod+D".action.spawn = [ "fuzzel" ];
        "Mod+Q".action = "close-window";
        "Mod+Shift+E".action = "quit";
        "Mod+Shift+Slash".action = "show-hotkey-overlay";
        "Mod+Left".action = "focus-column-left";
        "Mod+Right".action = "focus-column-right";
        "Mod+Up".action = "focus-window-up";
        "Mod+Down".action = "focus-window-down";
        "Mod+Shift+Left".action = "move-column-left";
        "Mod+Shift+Right".action = "move-column-right";
        "Mod+Shift+Up".action = "move-window-up";
        "Mod+Shift+Down".action = "move-window-down";
        "Mod+1".action = "focus-workspace 1";
        "Mod+2".action = "focus-workspace 2";
        "Mod+3".action = "focus-workspace 3";
        "Mod+4".action = "focus-workspace 4";
        "Mod+5".action = "focus-workspace 5";
        "Mod+6".action = "focus-workspace 6";
        "Mod+7".action = "focus-workspace 7";
        "Mod+8".action = "focus-workspace 8";
        "Mod+9".action = "focus-workspace 9";
        "Mod+L".action.spawn = [ "swaylock" ];
      };
      spawn-at-startup = [
        { command = [ "waybar" ]; }
        { command = [ "mako" ]; }
      ];
    };
  };

  # --- Waybar ---
  programs.waybar = {
    enable = true;
    settings = [{
      layer = "top";
      position = "top";
      height = 28;
      modules = [
        "niri/workspaces"
        "clock"
        "tray"
        "pulseaudio"
      ];
      "niri/workspaces" = {
        format = "{index}";
      };
      clock = {
        format = "{:%H:%M %d.%m}";
      };
      pulseaudio = {
        format = "{volume}% {icon}";
        format-muted = "🔇";
      };
    }];
    style = """
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 13px;
      }
      window#waybar {
        background: #1d2021;
        color: #ebdbb2;
      }
      #workspaces button {
        padding: 0 8px;
      }
      #clock {
        padding: 0 10px;
      }
    """;
  };

  # --- Swaylock ---
  programs.swaylock.enable = true;

  # --- Mako (уведомления) ---
  services.mako.enable = true;

  # --- Swayidle ---
  services.swayidle = {
    enable = true;
    timeouts = [
      { timeout = 300; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock -f"; }
    ];
  };
}
