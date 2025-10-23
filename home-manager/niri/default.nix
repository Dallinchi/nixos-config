{ host
, config
, pkgs
, inputs
, lib
, ...
}:
let
  inherit
    (import ../../hosts/${host}/variables.nix)
    keyboardLayout
    ;
in
{
	imports = [
		inputs.niri.homeModules.niri
	];

  systemd.user.targets.niri-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  programs.niri = {
    enable = true;
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
        XDG_CURRENT_DESKTOP = "Niri";
        XDG_SESSION_TYPE = "wayland";
        XDG_SESSION_DESKTOP = "Niri";
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

      # spawn-at-startup =
      #   let
      #     sh = [
      #       "sh"
      #       "-c"
      #     ];
      #   in
      #   [
      #     { command = sh ++ [ "wl-clip-persist --clipboard regular" ]; }
      #     { command = sh ++ [ "cliphist wipe" ]; }
      #     { command = sh ++ [ "systemctl --user start cliphist-text.service" ]; }
      #     { command = sh ++ [ "systemctl --user start cliphist-image.service" ]; }
      #     { command = sh ++ [ "systemctl --user start hypridle.service" ]; }
      #     { command = sh ++ [ "systemctl --user start waybar.service" ]; }
      #     { command = sh ++ [ "systemctl --user start swaybg.service" ]; }
      #     { command = sh ++ [ "systemctl --user start swaync.service" ]; }
      #     { command = sh ++ [ "sleep 1 && blueman-applet" ]; }
      #     { command = sh ++ [ "sleep 3 && syncthingtray --wait" ]; }
      #     { command = sh ++ [ "id=0" ]; }
      #     { command = [ "swayosd-server" ]; }
      #     { command = [ "nm-applet" ]; }
      #   ];
      outputs."HDMI-A-1" = {
        mode = {
          height = 900;
          width = 1440;
          refresh = 59.901;
        };
        transform = {
          rotation = 90;
        };
        position = {
         x = -1920;
         y = -360;
        };
      };
      input = {
        power-key-handling.enable = false;
        warp-mouse-to-focus.enable = true;

        mouse = {
          accel-speed = 0;
        };

        touchpad = {
          accel-speed = 0;
          scroll-factor = 0.4;
        };

        keyboard = {
          xkb.layout = keyboardLayout;
          xkb.options = "grp:alt_shift_toggle";
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
          "Super+Tab".action = toggle-overview;
          "Super+L".action = focus-column-or-monitor-right;
          "Super+H".action = focus-column-or-monitor-left;
          "Super+K".action = focus-window-or-workspace-up;
          "Super+J".action = focus-window-or-workspace-down;
          "Super+F".action = fullscreen-window;
          "Super+A".action = maximize-column;
          "Super+S".action = expand-column-to-available-width;
          "Super+D".action = sh "pkill rofi || rofi -config ~/.config/rofi/config-menu.rasi -show drun -monitor eDP-1"; # launcher
          "Super+V".action = sh "pkill rofi || cliphist list | rofi -config ~/.config/rofi/config-cliphist.rasi -dmenu -monitor eDP-1 | cliphist decode | wl-copy"; # clipboard history
           # "Super+L".action = sh "loginctl lock-session"; # lock screen
          "Super+P".action = sh "pidof wofi-power-menu || wofi-power-menu"; # power options
          "Super+Y".action = sh "swaync-client -t"; # notification hub
          "Super+Return".action = spawn "alacritty"; # terminal
          "Super+C".action = spawn "qalculate-gtk"; # calculator
          "Super+B".action = sh "pidof wl-color-picker || wl-color-picker"; # color-picker
          
          "Super+Shift+Space".action = toggle-window-floating;
          "Super+Shift+L".action = consume-or-expel-window-right;
          "Super+Shift+H".action = consume-or-expel-window-left;
          "Super+Shift+K".action = move-window-up-or-to-workspace-up;
          "Super+Shift+J".action = move-window-down-or-to-workspace-down;
          "Super+Shift+grave".action = move-window-to-monitor-next;
          "Super+Shift+R".action = switch-preset-column-width;
          "Super+Shift+A".action = switch-preset-window-height;
          "Super+Shift+Tab".action = toggle-column-tabbed-display;
          "Super+Shift+Q".action = close-window;
          
          "Super+grave".action = focus-monitor-next;
          "Super+1".action = focus-workspace 1;
          "Super+2".action = focus-workspace 2;
          "Super+3".action = focus-workspace 3;
          "Super+4".action = focus-workspace 4;
          "Super+5".action = focus-workspace 5;
          "Super+6".action = focus-workspace 6;
          "Super+7".action = focus-workspace 7;
          "Super+8".action = focus-workspace 8;
          
          # "Print".action = screenshot;
          "XF86PowerOff".action = sh "pidof wofi-power-menu || wofi-power-menu";
          "XF86AudioMute".action = sh "swayosd-client --output-volume=mute-toggle";
          "XF86AudioPlay".action = sh "playerctl play-pause";
          "XF86AudioPrev".action = sh "playerctl previous";
          "XF86AudioNext".action = sh "playerctl next";
          "XF86AudioRaiseVolume".action = sh "swayosd-client --output-volume=raise";
          "XF86AudioLowerVolume".action = sh "swayosd-client --output-volume=lower";
          "XF86MonBrightnessUp".action = sh "swayosd-client --brightness=raise";
          "XF86MonBrightnessDown".action = sh "swayosd-client --brightness=lower";
        };

      gestures.hot-corners.enable = false;
     
      layout = {
        gaps = 8;
        default-column-width.proportion = 0.5;
        always-center-single-column = true;
        insert-hint.display = {
          color = "rgba(224, 224, 224, 30%)";
        };

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
          width = 2;
          active = {
            color = "#e0e0e0ff";
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

      overview.backdrop-color = "#0f0f0f";
      
      workspaces = {
        # "2-docs" = {
        #   name = "docs";
        #   open-on-output = "HDMI-A-1";
        # };
        "4-chat" = {
          name = "chat";
          open-on-output = "HDMI-A-1";
        };

        "1-media" = {
          name = "media";
          open-on-output = "eDP-1";
        };
        "3-code" = {
          name = "code";
          open-on-output = "eDP-1";
        };
        "5-game" = {
          name = "game";
          open-on-output = "eDP-1";
        };
      };
      
      window-rules = [
        {
          # Decoration
          geometry-corner-radius =
            let
              radius = 8.0;
            in
            {
              bottom-left = radius;
              bottom-right = radius;
              top-left = radius;
              top-right = radius;
            };
          clip-to-geometry = true;
          draw-border-with-background = false;
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
      ];
    };
  };
}
