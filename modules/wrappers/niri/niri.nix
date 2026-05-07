{
  self,
  inputs,
  ...
}: {
  perSystem = {pkgs, lib, config, ...}: let
    
    noctalia-shell = self.packages.${pkgs.stdenv.hostPlatform.system}.noctalia-shell;

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
    
    scriptOverviewAction = pkgs.writeScriptBin "niri-overview-actions" (
      builtins.readFile ./scripts/niri-overview-actions
    ); 
    
    scriptToggleMouseLock = pkgs.writeScriptBin "niri-toggle-mouse-lock" (
      builtins.readFile ./scripts/niri-toggle-mouse-lock
    ); 

    conf =
      pkgs.writeTextFile {
        name = "niri-config.kdl";
        text = ''
        input {
          keyboard {
            xkb {
              layout "us, ru"
              model "pc86"
              rules ""
              variant ""
              options "grp:alt_shift_toggle"
            }
            repeat-delay 250
            repeat-rate 65
            track-layout "window"
          }
          touchpad {
            tap
            natural-scroll
            accel-speed 0
            scroll-factor 0.400000
          }
          mouse {
            accel-speed 0
            accel-profile "flat"
          }
          warp-mouse-to-focus
          focus-follows-mouse max-scroll-amount="95%"
          disable-power-key-handling
        }

        output "DP-1" {
          transform "normal"
          position x=0 y=0
          mode "1920x1080@200.000000"
        }

        output "HDMI-A-1" {
          transform "90"
          position x=0 y=-420
          mode "1920x1080@100.000000"
        }

        screenshot-path "~/Pictures/Screenshots/%Y-%m-%d-%H%M%S.png"
          prefer-no-csd
          overview {
            backdrop-color "#11151c"
            workspace-shadow { off; }
          }

        layout {
          gaps 12
          struts {
            left 0
            right 0
            top 0
            bottom 0
          }
          focus-ring {
            width 1
            active-color "#6c7380"
            inactive-color "#00000000"
          }
          border { off; }
          background-color "transparent"
          tab-indicator {
            place-within-column
            gap 8
            width 8
            length total-proportion=1.000000
            position "top"
            gaps-between-tabs 8
            corner-radius 8
            active-color "rgba(224, 224, 224, 100%)"
            inactive-color "rgba(224, 224, 224, 30%)"
          }
          insert-hint { color "rgba(224, 224, 224, 30%)"; }
          default-column-width { proportion 0.500000; }
          preset-column-widths {
            proportion 0.333333
            proportion 0.500000
            proportion 0.666667
          }
          preset-window-heights {
            proportion 0.333333
            proportion 0.500000
            proportion 0.666667
            proportion 1.000000
          }
          center-focused-column "always"
          always-center-single-column
        }

        cursor {
          xcursor-theme "default"
          xcursor-size 24
          hide-when-typing
          hide-after-inactive-ms 1500
        }

        hotkey-overlay { skip-at-startup; }
        environment {
          "CLUTTER_BACKEND" "wayland"
          EDITOR "nvim"
          "ELECTRON_OZONE_PLATFORM_HINT" "wayland"
          "ELM_DISPLAY" "wl"
          "GDK_BACKEND" "wayland,x11"
          "GDK_SCALE" "1"
          "MOZ_ENABLE_WAYLAND" "1"
          "NIXOS_OZONE_WL" "1"
          "QT_AUTO_SCREEN_SCALE_FACTOR" "1"
          "QT_QPA_PLATFORM" "wayland;xcb"
          "QT_SCALE_FACTOR" "1"
          "QT_WAYLAND_DISABLE_WINDOWDECORATION" "1"
          "SDL_VIDEODRIVER" "wayland,x11"
          TERMINAL "alacritty"
          "XDG_CURRENT_DESKTOP" "niri"
          "XDG_SESSION_DESKTOP" "niri"
          "XDG_SESSION_TYPE" "wayland"
          "XDG_TERMINAL_EMULATOR" "alacritty"
        }

        binds {
          Print { screenshot; }
          Super+1 { focus-workspace 1; }
          Super+2 { focus-workspace 2; }
          Super+3 { focus-workspace 3; }
          Super+4 { focus-workspace 4; }
          Super+5 { focus-workspace 5; }
          Super+6 { focus-workspace 6; }
          Super+7 { focus-workspace 7; }
          Super+8 { focus-workspace 8; }
          Super+A { maximize-column; }

          Super+Alt+K { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --playerctl play-pause"; }
          Super+Alt+N { spawn "sh" "-c" "playerctl next"; }
          Super+Alt+P { spawn "sh" "-c" "playerctl previous"; }

          Super+D { spawn "sh" "-c" "pkill wlr-which-key || ${(lib.getExe (mkMenu [
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
                        cmd = "zen-twilight -P whiteside";
                      }
                      {
                        key = "v";
                        desc = "Default VPN browser";
                        cmd = "alacritty -T \"Password to enter the namespace\" -e exec-in-namespace ns_vpn zen-twilight -P darkside";
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

            ]))}"; }
          Super+F2 { spawn "sh" "-c" "${lib.getExe scriptToggleMouseLock}"; }
          Super+H { focus-column-left; }
          Super+F { maximize-window-to-edges; }
          Super+J { focus-window-or-workspace-down; }
          Super+K { focus-window-or-workspace-up; }
          Super+L { focus-column-right; }
          Super+Return repeat=false { spawn "kitty"; }
          Super+S { expand-column-to-available-width; }
          Super+Tab repeat=false { toggle-overview; }
          Super+V { spawn "sh" "-c" "pkill rofi || cliphist list | rofi -config ~/.config/rofi/config-cliphist.rasi -dmenu | cliphist decode | wl-copy"; }
          Super+grave { focus-monitor-next; }

          Super+Shift+A { switch-preset-window-height; }
          Super+Shift+F { fullscreen-window; }
          Super+Shift+H { consume-or-expel-window-left; }
          Super+Shift+J { move-window-down-or-to-workspace-down; }
          Super+Shift+K { move-window-up-or-to-workspace-up; }
          Super+Shift+L { consume-or-expel-window-right; }
          Super+Shift+N { spawn "sh" "-c" "niri msg output \"HDMI-A-1\" transform normal"; }
          Super+Shift+Q { close-window; }
          Super+Shift+R { switch-preset-column-width; }
          Super+Shift+Space { toggle-window-floating; }
          Super+Shift+T { switch-focus-between-floating-and-tiling; }
          Super+Shift+Tab { toggle-column-tabbed-display; }
          Super+Shift+V { spawn "sh" "-c" "niri msg output \"HDMI-A-1\" transform 90"; }
          Super+Shift+grave { move-window-to-monitor-next; }

          XF86AudioLowerVolume { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --output-volume -5"; }
          XF86AudioMicMute { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --input-volume mute-toggle"; }
          XF86AudioMute { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --output-volume mute-toggle"; }
          XF86AudioNext { spawn "sh" "-c" "playerctl next"; }
          XF86AudioPlay { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --playerctl play-pause"; }
          XF86AudioPrev { spawn "sh" "-c" "playerctl previous"; }
          XF86AudioRaiseVolume { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --output-volume +5"; }
          XF86MonBrightnessDown { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --brightness -25"; }
          XF86MonBrightnessUp { spawn "sh" "-c" "swayosd-client --monitor HDMI-A-1 --brightness +25"; }
        }
        workspace "media" { open-on-output "DP-1"; }
        workspace "docs" { open-on-output "HDMI-A-1"; }
        workspace "code" { open-on-output "DP-1"; }
        workspace "chat" { open-on-output "HDMI-A-1"; }
        workspace "game" { open-on-output "DP-1"; }
        spawn-at-startup "sh" "-c" "wl-paste --type text --watch cliphist store"
        spawn-at-startup "sh" "-c" "wl-paste --type image --watch cliphist store"
        spawn-at-startup "sh" "-c" "${lib.getExe scriptOverviewAction}"
        spawn-at-startup "sh" "-c" "${lib.getExe noctalia-shell}"
        spawn-at-startup "yandex-music"
        spawn-at-startup "zen-twilight"
        spawn-at-startup "steam"

        window-rule {
          open-focused true
          draw-border-with-background false
          geometry-corner-radius 5.000000 5.000000 5.000000 5.000000
          clip-to-geometry true

          opacity 0.9

          background-effect {
            xray true
            blur true
            noise 0.05
            saturation 3
          }
        }

        window-rule {
          match is-active=true
          shadow {
            on
            offset x=0 y=0
            softness 5
            spread 5
          }
        }
        window-rule {
          match at-startup=true
          open-focused false
        }
        window-rule {
          match app-id="Alacritty" title="Bluetoothctl"
          match app-id="Alacritty" title="Nmtui"
          match app-id="Alacritty" title="Password to enter the namespace"
          match app-id="org.pulseaudio.pavucontrol" title="Volume Control"
          open-floating true
        }
        window-rule {
          match app-id="zen-twilight"
          match app-id="yandex-music"
          open-on-workspace "media"
        }
        window-rule {
          match app-id="Alacritty"
          match app-id="kitty"
          open-on-workspace "code"
        }
        window-rule {
          match app-id="steam"
          open-on-workspace "game"
        }
        window-rule {
          match app-id="com.chatterino."
          match app-id="org.telegram.desktop"
          match app-id="discord"
          open-on-workspace "chat"
        }
        window-rule {
          match app-id=".blueman-manager-wrapped"
          match app-id="nm-connection-editor"
          match app-id="com.saivert.pwvucontrol"
          match app-id="org.pipewire.Helvum"
          match app-id="com.github.wwmm.easyeffects"
          match app-id="wdisplays"
          match app-id="qalculate-gtk"
          match title="Syncthing Tray"
          open-floating true
        }
        window-rule {
          match app-id="com.chatterino"
          match app-id="discord"
          open-fullscreen true
        }
        window-rule {
          match app-id="steam" title="Steam"
          match app-id="zen-twilight"
          match app-id="org.telegram.desktop"
          open-maximized true
        }
        window-rule {
          match app-id="yandex-music"
          match app-id="steam" title="Список друзей"
          default-column-width { proportion 0.300000; }
        }
        window-rule {
          match is-window-cast-target=true
          focus-ring {
            active-color "rgba(224, 53, 53, 100%)"
            inactive-color "rgba(224, 53, 53, 30%)"
          }
          tab-indicator {
            active-color "rgba(224, 53, 53, 100%)"
            inactive-color "rgba(224, 53, 53, 30%)"
          }
        }
        layer-rule { geometry-corner-radius 5.000000 5.000000 5.000000 5.000000; }
        layer-rule {
          match namespace="waybar"
          match namespace="way-edges-widget"
          match namespace="wallpaper"
          match namespace="mpvpaper"
          place-within-backdrop true
        }
        gestures { hot-corners { off; }; }
        xwayland-satellite { path "${pkgs.lib.getExe pkgs.xwayland-satellite}";}


        animations {
          slowdown 0.5
        }
        '';
      };
      
  in {
    packages.niri = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.niri;

      wrapper = { exePath, ... }: ''
        #!${pkgs.bash}/bin/bash
        set -euo pipefail

        case "''${1:-}" in
          msg|validate|panic|completions|help|-v|-V|--version|--help|-h|--config|-c)
            exec "${pkgs.niri}/bin/niri" "$@"
            ;;
          *)
            export NIRI_CONFIG=${conf}
            exec "${pkgs.niri}/bin/niri-session"
            ;;
        esac
      '';
    };
  };
}
