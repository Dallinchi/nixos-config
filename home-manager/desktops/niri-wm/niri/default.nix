{ host
, system
, config
, pkgs
, inputs
, lib
, ...
}:
let
  inherit (import ../../../../hosts/${host}/variables.nix) keyboardLayout;
  inherit (inputs.nfsm-flake.packages.${pkgs.stdenv.hostPlatform.system}) nfsm nfsm-cli;

  mkMenu = menu: let
    configFile = pkgs.writeText "config.yaml"
      (pkgs.lib.generators.toYAML {} {
        anchor = "bottom";
        color = "#d3ebe9";
        border = "#6c7380";
        border_width = 1;
        corner_r = 5;
        padding = 5;
        margin_bottom = 5;
        background = "#11151c";
        rows_per_column = 5;
        column_padding = 25; # Defaults to padding
        inherit menu;
      });
    in
      pkgs.writeShellScriptBin "my-menu" ''
        exec ${pkgs.lib.getExe pkgs.wlr-which-key} ${configFile}
      '';
in
{
	imports = [
		inputs.niri.homeModules.niri
  ];

  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  
  # Shell scripts
  xdg.configFile = {
    "niri/scripts" = {
      source = ./scripts;
      recursive = true;
    };
    # "niri/config.kdl" = {
      # source = ./config.kdl;
    # };
  };
  
  home.packages = [ nfsm nfsm-cli ]; 
  
  # nixpkgs.overlays = [ inputs.niri.overlays.niri ];
  # niri-flake.cache.enable = false;

  programs.niri = {
    enable = true;
    package = pkgs.niri-unstable;
    settings = {
      prefer-no-csd = true;
      hotkey-overlay.skip-at-startup = true;
      screenshot-path = "~/Pictures/Screenshots/%Y-%m-%d-%H%M%S.png";
      xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

      environment = {
        ELM_DISPLAY = "wl";
        GDK_BACKEND = "wayland,x11";
        QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
        SDL_VIDEODRIVER = "wayland,x11";
        CLUTTER_BACKEND = "wayland";
        NIXOS_OZONE_WL = "1";
        XDG_CURRENT_DESKTOP = "niri";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "niri";
        QT_QPA_PLATFORM = "wayland;xcb";
        QT_AUTO_SCREEN_SCALE_FACTOR = "1";
        MOZ_ENABLE_WAYLAND = "1";
        # This is to make electron apps start in wayland
        ELECTRON_OZONE_PLATFORM_HINT = "wayland";
        # Disabling this by default as it can result in inop cfg
        # Added card2 in case this gets enabled. For better coverage
        # This is mostly needed by Hybrid laptops.
        # but if you have multiple discrete GPUs this will set order
        #"AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1:/dev/card2"
        GDK_SCALE = "1";
        QT_SCALE_FACTOR = "1";
        EDITOR = "nvim";
        # Set terminal and xdg_terminal_emulator to kitty
        # To provent yazi from starting xterm when run from rofi menu
        # You can set to your preferred terminal if you you like
        # ToDo: Pull default terminal from config
        TERMINAL = "alacritty";
        XDG_TERMINAL_EMULATOR = "alacritty";

      };

      spawn-at-startup =
        let
          sh = [
            "sh"
            "-c"
          ];
        in
        [
          { command = sh ++ [ "wl-paste --type text --watch cliphist store" ]; }
          { command = sh ++ [ "wl-paste --type image --watch cliphist store" ]; }
          { command = sh ++ [ "~/.config/niri/scripts/overview-bar" ]; }
          { command = sh ++ [ "swaybg -i $(find ~/Pictures/Wallpapers/* | shuf -n 1) -m fill" ]; }
          { command = sh ++ [ "nfsm" ]; }
        ];

      outputs =
        if host == "hero-pro" then {
          "HDMI-A-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 200.0;
            };
            # transform = {
            #   rotation = 90;
            # };
            position = {
              x = 1920;
              y = 0;
            };
          };

          "DVI-D-1" = {
            mode = {
              width = 1440;
              height = 900;
              refresh = 74.984;
            };
            transform = {
              rotation = 90;
            };
            position = {
              x = 0;
              y = 0;
            };
          };

        } else if host == "hero" then {
          "HDMI-A-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 120.0;
            };
            transform = {
              rotation = 90;
            };
            position = {
              x = -1920;
              y = 0;
            };
          };

          "eDP-1" = {
            mode = {
              width = 1920;
              height = 1080;
              refresh = 60.027;
            };
            position = {
              x = 0;
              y = 0;
            };
          };

        } else {};

      input = {
        power-key-handling.enable = false;
        warp-mouse-to-focus.enable = true;

        mouse = {
          accel-speed = 0;
          accel-profile = "flat";
        };

        touchpad = {
          accel-speed = 0;
          scroll-factor = 0.4;
        };

        keyboard = {
          xkb.layout = keyboardLayout;
          xkb.options = "grp:alt_shift_toggle";
          xkb.model = "pc86";
          track-layout = "window";
          repeat-delay = 250;
      	  repeat-rate = 65; 
        };

        focus-follows-mouse = {
          enable = true;
          max-scroll-amount = "95%";
        };
      };

      cursor = {
        hide-after-inactive-ms = 1500;
        hide-when-typing = true;
      };

      binds =
        with config.lib.niri.actions;
        let
          sh = spawn "sh" "-c";
        in
        {
          "Super+Tab".repeat = false;
          "Super+Tab".action = toggle-overview;
          "Super+L".action = focus-column-right;
          "Super+H".action = focus-column-left;
          "Super+K".action = focus-window-or-workspace-up;
          "Super+J".action = focus-window-or-workspace-down;
          "Super+F".action = spawn "nfsm-cli";
          "Super+A".action = maximize-column;
          "Super+S".action = expand-column-to-available-width;
          "Super+V".action = sh "pkill rofi || cliphist list | rofi -config ~/.config/rofi/config-cliphist.rasi -dmenu | cliphist decode | wl-copy"; # clipboard history
          "Super+F2".action = sh "~/.config/niri/scripts/toggle_mouselock_monitor"; # toggle monitor mouse lock
          "Super+Return".action = spawn "alacritty"; # terminal
          # "Super+N".action = sh "alacritty -T \"Nmtui\" -e nmtui";
          # "Super+B".action = sh "alacritty -T \"Bluetoothctl\" -e bluetoothctl";
          # "Super+R".action = sh "pavucontrol";
          

          "Super+D".action = sh "pkill wlr-which-key || ${(lib.getExe (mkMenu [
            {
              key = "d";
              desc = "Launcher";
              cmd = "sh -c pkill rofi && niri msg action close-overview || niri msg action open-overview | rofi -config ~/.config/rofi/config-menu.rasi -show drun; niri msg action close-overview";
            }
            {
              key = "c";
              desc = "CLI | TUI";
              submenu = [
                {
                  key = "t";
                  desc = "Terminal";
                  cmd = "alacritty";
                }
                {
                  key = "e";
                  desc = "Files";
                  cmd = "alacritty -e yazi";
                }
                {
                  key = "b";
                  desc = "Bluetoothctl";
                  cmd = "alacritty -T \"Bluetoothctl\" -e bluetoothctl";
                }
                {
                  key = "n";
                  desc = "Network";
                  cmd = "alacritty -T \"Nmtui\" -e nmtui";
                }
                {
                  key = "h";
                  desc = "Btop";
                  cmd = "alacritty -e btop";
                }
                {
                  key = "c";
                  desc = "Neovim";
                  cmd =  "alacritty -e sh -c \"cd ${config.home.homeDirectory}/Documents/quotes && exec nvim\"";
                }
              ];
            }
            {
              key = "g";
              desc = "GUI";
              submenu = [
                {
                  key = "e";
                  desc = "Files";
                  cmd = "nautilus";
                }
                {
                  key = "b";
                  desc = "Browser";
                  submenu = [
                    {
                      key = "b";
                      desc = "Default browser";
                      cmd = "zen";
                    }
                    {
                      key = "v";
                      desc = "Default VPN browser";
                      cmd = "alacritty -T \"Password to enter the namespace\" -e exec-in-namespace ns_vpn zen -P darkside";
                    }
                  ];
                }
                {
                  key = "s";
                  desc = "Steam";
                  cmd = "steam";
                }
                {
                  key = "r";
                  desc = "Sound Control";
                  cmd = "pavucontrol";
                }
                {
                  key = "o";
                  desc = "Obsidian";
                  cmd = "obsidian";
                }
                {
                  key = "t";
                  desc = "Telegram";
                  cmd = "alacritty -T \"Password to enter the namespace\" -e exec-in-namespace ns_vpn Telegram";
                }
                {
                  key = "d";
                  desc = "Discord";
                  cmd = "alacritty -T \"Password to enter the namespace\" -e exec-in-namespace ns_vpn discord";
                }
                {
                  key = "c";
                  desc = "Chatterino";
                  cmd = "alacritty -T \"Password to enter the namespace\" -e exec-in-namespace ns_vpn chatterino";
                }
                {
                  key = "m";
                  desc = "Yandex Music";
                  cmd = "yandex-music";
                }
              ];
            }

          ]))}";
          
          "Super+Shift+Space".action = toggle-window-floating;
          "Super+Shift+T".action = switch-focus-between-floating-and-tiling;
          "Super+Shift+L".action = consume-or-expel-window-right;
          "Super+Shift+H".action = consume-or-expel-window-left;
          "Super+Shift+K".action = move-window-up-or-to-workspace-up;
          "Super+Shift+J".action = move-window-down-or-to-workspace-down;
          "Super+Shift+grave".action = move-window-to-monitor-next;
          "Super+Shift+R".action = switch-preset-column-width;
          "Super+Shift+A".action = switch-preset-window-height;
          "Super+Shift+Tab".action = toggle-column-tabbed-display;
          "Super+Shift+Q".action = close-window;
          "Super+Shift+V".action = sh "niri msg output \"DVI-D-1\" transform 90";
          "Super+Shift+N".action = sh "niri msg output \"DVI-D-1\" transform normal";

          "Super+grave".action = focus-monitor-next;
          "Super+1".action = focus-workspace 1;
          "Super+2".action = focus-workspace 2;
          "Super+3".action = focus-workspace 3;
          "Super+4".action = focus-workspace 4;
          "Super+5".action = focus-workspace 5;
          "Super+6".action = focus-workspace 6;
          "Super+7".action = focus-workspace 7;
          "Super+8".action = focus-workspace 8;

          "Print".action.screenshot = [];
          "XF86AudioMute".action = sh "swayosd-client --output-volume mute-toggle";
          "XF86AudioMicMute".action = sh "swayosd-client --input-volume mute-toggle";
          "XF86AudioPlay".action = sh "swayosd-client --playerctl play-pause";
          "XF86AudioPrev".action = sh "playerctl previous";
          "XF86AudioNext".action = sh "playerctl next";
          "XF86AudioRaiseVolume".action = sh "swayosd-client --output-volume +5";
          "XF86AudioLowerVolume".action = sh "swayosd-client --output-volume -5";
          "XF86MonBrightnessUp".action = sh "swayosd-client --brightness +25";
          "XF86MonBrightnessDown".action = sh "swayosd-client --brightness -25";

          # "Super+Ctrl+C".action = sh "alacritty -e nvim";
          # "Super+CTRL+D".action = sh "pkill rofi && niri msg action close-overview || niri msg action open-overview | rofi -config ~/.config/rofi/config-menu.rasi -show drun; niri msg action close-overview"; # launcher
          # "Super+Ctrl+B".action = spawn "zen-twilight";
          # "Super+Ctrl+O".action = spawn "obsidian";
          # "Super+Ctrl+E".action = sh "alacritty -e yazi";
          # "Super+Ctrl+M".action = spawn "yandex-music";
          # "Super+Ctrl+T".action = spawn "Telegram";

          "Super+Alt+N".action = sh "playerctl next";
          "Super+Alt+P".action = sh "playerctl previous";
          "Super+Alt+K".action = sh "swayosd-client --playerctl play-pause";
        };

      gestures.hot-corners.enable = false;

      layout = {
        gaps = 12;
        default-column-width.proportion = 0.5;
        always-center-single-column = true;
        center-focused-column = "never"; # one of "never", "always", "on-overflow"
        insert-hint.display = {
          color = "rgba(224, 224, 224, 30%)";
        };
        # background-color = "#242936";
        background-color = "transparent";
        preset-column-widths = [
          { proportion = 1.0 / 3.0; }
          { proportion = 0.5; }
          { proportion = 2.0 / 3.0; }
        ];

        preset-window-heights = [
          { proportion = 1.0 / 3.0; }
          { proportion = 0.5; }
          { proportion = 2.0 / 3.0; }
          { proportion = 1.0; }
        ];

        border.enable = false;
        focus-ring = {
          enable = true;
          width = 1;
          active = {
            color = "#6c7380";
          };
          inactive = {
            color = "#00000000";
          };
        };

        tab-indicator = {
          enable = true;
          place-within-column = true;
          width = 8;
          corner-radius = 8;
          gap = 8;
          gaps-between-tabs = 8;
          position = "top";
          active = {
            color = "rgba(224, 224, 224, 100%)";
          };
          inactive = {
            color = "rgba(224, 224, 224, 30%)";
          };
          length.total-proportion = 1.0;
        };
      };

      overview.backdrop-color = "#11151c";
      # overview.zoom = 0.4;
      overview.workspace-shadow.enable = false;

      workspaces = {
        "2-docs" = {
          name = "docs";
          open-on-output = "DVI-D-1";
        };
        "4-chat" = {
          name = "chat";
          # open-on-output = "HDMI-A-1";
          open-on-output = "DVI-D-1";
        };

        "1-media" = {
          name = "media";
          # open-on-output = "eDP-1";
          open-on-output = "HDMI-A-1";
        };
        "3-code" = {
          name = "code";
          # open-on-output = "eDP-1";
          open-on-output = "HDMI-A-1";
        };
        "5-game" = {
          name = "game";
          # open-on-output = "eDP-1";
          open-on-output = "HDMI-A-1";
        };
      };

      layer-rules = [
        {
          geometry-corner-radius =
            let
              radius = 5.0;
            in
            {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
        }
        {
          matches = [
            { namespace="waybar"; }
            { namespace="way-edges-widget"; }
            { namespace="wallpaper"; }
            { namespace="mpvpaper"; }
          ];
          place-within-backdrop = true;
        }
      ];

      window-rules = [
        {
          # For all
          geometry-corner-radius =
            let
              radius = 5.0;
            in
            {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
          clip-to-geometry = true;
          draw-border-with-background = false;
          open-focused = true;
        }
          # Active window
        {
          matches = [
            { is-active = true; }
          ];

          shadow = {
            enable = true;
            softness = 5;
            spread = 5;
            offset.x = 0;
            offset.y = 0;
          };

        }
        {
          # Open silince
          matches = [
            { app-id = "steam"; }
          ];
          open-focused = false;
        }
        {
          # Open in float
          matches = [
            { app-id = "Alacritty"; title = "Bluetoothctl"; }
            { app-id = "Alacritty"; title = "Nmtui"; }
            { app-id = "Alacritty"; title = "Password to enter the namespace"; }
            { app-id = "org.pulseaudio.pavucontrol"; title = "Volume Control"; }
          ];
          open-floating = true;
        }
        {
          # Open in media workspace
          matches = [
            { app-id = "zen-twilight"; }
            { app-id = "yandex-music"; }
          ];
          open-on-workspace = "media";
        }
        {
          # Open in code workspace
          matches = [
            { app-id = "Alacritty"; }
          ];
          open-on-workspace = "code";
        }
        {
          # Open in game workspace
          matches = [
            { app-id = "steam"; }
          ];
          open-on-workspace = "game";
        }
        # {
          # Open in docs workspace
          # matches = [
            # { app-id = "zen-twilight"; title = "(?i)github"; }
          # ];
          # open-on-workspace = "docs";
        # }
        {
          # Open in chat workspace
          matches = [
            { app-id = "com.chatterino."; }
            { app-id = "org.telegram.desktop"; }
            { app-id = "discord"; }
          ];
          open-on-workspace = "chat";
        }
        {
          # Floating
          matches = [
            { app-id = ".blueman-manager-wrapped"; }
            { app-id = "nm-connection-editor"; }
            { app-id = "com.saivert.pwvucontrol"; }
            { app-id = "org.pipewire.Helvum"; }
            { app-id = "com.github.wwmm.easyeffects"; }
            { app-id = "wdisplays"; }
            { app-id = "qalculate-gtk"; }
            { title = "Syncthing Tray"; }
          ];
          open-floating = true;
        }
        {
          # Fullscreen
          matches = [
            { app-id = "steam"; }
            { app-id = "com.chatterino"; }
            { app-id = "discord"; }
          ];
          open-fullscreen = true;
        }
        {
          # Maximized
          matches = [
            { app-id = "steam"; }
            { app-id = "zen-twilight"; }
            { app-id = "org.telegram.desktop"; }
          ];
          open-maximized = true;
        }
        {
          matches = [
            { is-window-cast-target = true; }
          ];

          focus-ring = {
            active = {
              color = "rgba(224, 53, 53, 100%)";
            };
            inactive = {
              color = "rgba(224, 53, 53, 30%)";
            };
          };

          tab-indicator = {
            active = {
              color = "rgba(224, 53, 53, 100%)";
            };
            inactive = {
              color = "rgba(224, 53, 53, 30%)";
            };
          };
        }
        {
          matches = [
            { app-id = "yandex-music"; }
          ];
          
          default-column-width.proportion = 0.2;
        }
      ];
    };
  };
}
