{ host
, config
, pkgs
, inputs
, lib
, ...
}:
{
  programs.waybar = {
  enable = true;
  systemd = {
    enable = false;
    target = "graphical-session.target";
  };
  settings = [
    {
      layer = "top";
      position = "top";
      # output = "eDP-1";
      # mode = "dock"; # Fixes fullscreen issues
      exclusive = false;
      passthrough = false;
      gtk-layer-shell = false;
      start_hidden = true;
      height = 0; # 35
      on-sigusr1 = "show";  
      on-sigusr2 = "hide";
      # start-hidden = true;
      # ipc = true;
      # fixed-center = true;
      # margin-top = 10;
      # margin-left = 10;
      # margin-right = 10;
      # margin-bottom = 0;

      modules-left = ["clock"];
      # modules-center = ["clock" "custom/notification"];
      # modules-center = ["idle_inhibitor" "clock"];
      modules-right = ["tray" "pulseaudio" "pulseaudio#microphone" "battery"];

      # "custom/notification" = {
      #   tooltip = false;
      #   format = "{icon}";
      #   format-icons = {
      #     notification = "<span foreground='red'><sup></sup></span>";
      #     none = "";
      #     dnd-notification = "<span foreground='red'><sup></sup></span>";
      #     dnd-none = "";
      #     inhibited-notification = "<span foreground='red'><sup></sup></span>";
      #     inhibited-none = "";
      #     dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
      #     dnd-inhibited-none = "";
      #   };
      #   return-type = "json";
      #   exec-if = "which swaync-client";
      #   exec = "swaync-client -swb";
      #   on-click = "swaync-client -t -sw";
      #   on-click-right = "swaync-client -d -sw";
      #   escape = true;
      # };
      #
      # "custom/colour-temperature" = {
      #   format = "{} ";
      #   exec = "wl-gammarelay-rs watch {t}";
      #   on-scroll-up = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n +100";
      #   on-scroll-down = "busctl --user -- call rs.wl-gammarelay / rs.wl.gammarelay UpdateTemperature n -100";
      # };
      # "custom/cava_mviz" = {
      #   exec = "${../../scripts/WaybarCava.sh}";
      #   format = "{}";
      # };
      # "cava" = {
      #   hide_on_silence = false;
      #   framerate = 60;
      #   bars = 10;
      #   format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
      #   input_delay = 1;
      #   # "noise_reduction" = 0.77;
      #   sleep_timer = 5;
      #   bar_delimiter = 0;
      #   on-click = "playerctl play-pause";
      # };
      # "custom/gpuinfo" = {
      #   exec = "${../../scripts/gpuinfo.sh}";
      #   return-type = "json";
      #   format = " {}";
      #   interval = 5; # once every 5 seconds
      #   tooltip = true;
      #   max-length = 1000;
      # };
      # "custom/icon" = {
      #   # format = " ";
      #   exec = "echo ' '";
      #   format = "{}";
      # };
      # "mpris" = {
      #   format = "{player_icon} {title} - {artist}";
      #   format-paused = "{status_icon} <i>{title} - {artist}</i>";
      #   player-icons = {
      #     default = "▶";
      #     spotify = "";
      #     mpv = "󰐹";
      #     vlc = "󰕼";
      #     firefox = "";
      #     chromium = "";
      #     kdeconnect = "";
      #     mopidy = "";
      #   };
      #   status-icons = {
      #     paused = "⏸";
      #     playing = "";
      #   };
      #   ignored-players = ["firefox" "chromium"];
      #   max-length = 30;
      # };
      # "temperature" = {
      #   hwmon-path = "/sys/class/hwmon/hwmon1/temp1_input";
      #   critical-threshold = 83;
      #   format = "{icon} {temperatureC}°C";
      #   format-icons = ["" "" ""];
      #   interval = 10;
      # };
      # "hyprland/language" = {
      #   format = "{short}"; # can use {short} and {variant}
      #   on-click = "${../../scripts/keyboardswitch.sh}";
      # };
      # "hyprland/workspaces" = {
      #   disable-scroll = true;
      #   all-outputs = true;
      #   active-only = false;
      #   on-click = "activate";
      #   persistent-workspaces = {
      #     "*" = [1 2 3 4 5 6 7 8 9 10];
      #   };
      # };
      #
      # "hyprland/window" = {
      #   format = "  {}";
      #   separate-outputs = true;
      #   rewrite = {
      #     "harvey@hyprland =(.*)" = "$1 ";
      #     "(.*) — Mozilla Firefox" = "$1 󰈹";
      #     "(.*)Mozilla Firefox" = " Firefox 󰈹";
      #     "(.*) - Visual Studio Code" = "$1 󰨞";
      #     "(.*)Visual Studio Code" = "Code 󰨞";
      #     "(.*) — Dolphin" = "$1 󰉋";
      #     "(.*)Spotify" = "Spotify 󰓇";
      #     "(.*)Spotify Premium" = "Spotify 󰓇";
      #     "(.*)Steam" = "Steam 󰓓";
      #   };
      #   max-length = 1000;
      # };
      #
      # "idle_inhibitor" = {
      #   format = "{icon}";
      #   format-icons = {
      #     activated = "󰥔";
      #     deactivated = "";
      #   };
      # };

      "clock" = {
        format = "{:%a %d %b %R}";
        # format = "{:%R 󰃭 %d·%m·%y}";
        format-alt = "{:%I:%M %p}";
        tooltip-format = "<tt>{calendar}</tt>";
        calendar = {
          mode = "month";
          mode-mon-col = 3;
          on-scroll = 1;
          on-click-right = "mode";
          format = {
            months = "<span color='#ffead3'><b>{}</b></span>";
            weekdays = "<span color='#ffcc66'><b>{}</b></span>";
            today = "<span color='#ff6699'><b>{}</b></span>";
          };
        };
        actions = {
          on-click-right = "mode";
          on-click-forward = "tz_up";
          on-click-backward = "tz_down";
          on-scroll-up = "shift_up";
          on-scroll-down = "shift_down";
        };
      };

      # "cpu" = {
      #   interval = 10;
      #   format = "󰍛 {usage}%";
      #   format-alt = "{icon0}{icon1}{icon2}{icon3}";
      #   format-icons = ["▁" "▂" "▃" "▄" "▅" "▆" "▇" "█"];
      # };
      #
      # "memory" = {
      #   interval = 30;
      #   format = "󰾆 {percentage}%";
      #   format-alt = "󰾅 {used}GB";
      #   max-length = 10;
      #   tooltip = true;
      #   tooltip-format = " {used:.1f}GB/{total:.1f}GB";
      # };
      #
      # "backlight" = {
      #   format = "{icon} {percent}%";
      #   format-icons = ["" "" "" "" "" "" "" "" ""];
      #   on-scroll-up = "${pkgs.brightnessctl}/bin/brightnessctl set 2%+";
      #   on-scroll-down = "${pkgs.brightnessctl}/bin/brightnessctl set 2%-";
      # };

      # "network" = {
      #   # on-click = "nm-connection-editor";
      #   # "interface" = "wlp2*"; # (Optional) To force the use of this interface
      #   format-wifi = "󰤨 Wi-Fi";
      #   # format-wifi = " {bandwidthDownBits}  {bandwidthUpBits}";
      #   # format-wifi = "󰤨 {essid}";
      #   format-ethernet = "󱘖 Wired";
      #   # format-ethernet = " {bandwidthDownBits}  {bandwidthUpBits}";
      #   format-linked = "󰤪 Secure";
      #   # format-linked = "󱘖 {ifname} (No IP)";
      #   format-disconnected = "󰤮 Off";
      #   # format-disconnected = "󰤮 Disconnected";
      #   format-alt = "󰤨 {signalStrength}%";
      #   tooltip-format = "󱘖 {ipaddr}  {bandwidthUpBytes}  {bandwidthDownBytes}";
      # };

      "bluetooth" = {
        format = "";
        # format-disabled = ""; # an empty format will hide the module
        format-connected = " {num_connections}";
        tooltip-format = " {device_alias}";
        tooltip-format-connected = "{device_enumerate}";
        tooltip-format-enumerate-connected = " {device_alias}";
        on-click = "blueman-manager";
      };

      "pulseaudio" = {
        format = "{icon}  {volume}%";
        format-muted = " ";
        on-click = "pavucontrol -t 3";
        tooltip-format = "{icon} {desc} // {volume}%";
        scroll-step = 4;
        format-icons = {
          headphone = "";
          hands-free = "";
          headset = "";
          phone = "";
          portable = "";
          car = "";
          default = ["" "" ""];
        };
      };

      "pulseaudio#microphone" = {
        format = "{format_source}";
        format-source = "  {volume}%";
        format-source-muted = "";
        on-click = "pavucontrol -t 4";
        tooltip-format = "{format_source} {source_desc} // {source_volume}%";
        scroll-step = 5;
      };

      "tray" = {
        icon-size = 12;
        spacing = 5;
      };

      "battery" = {
        states = {
          good = 95;
          warning = 30;
          critical = 20;
        };
        format = "{icon}  {capacity}%";
        # format-charging = " {capacity}%";
        format-charging = "  {capacity}%";
        format-plugged = "  {capacity}%";
        format-alt = "{time}  {icon}";
        format-icons = ["󰂎" "󰁺" "󰁻" "󰁼" "󰁽" "󰁾" "󰁿" "󰂀" "󰂁" "󰂂" "󰁹"];
      };

      # "custom/power" = {
      #   format = "{}";
      #   on-click = "wlogout -b 4";
      #   interval = 86400; # once every day
      #   tooltip = true;
      # };
    }
  ];
  style = ''
    * {
        border: none;
        border-radius: 0;
        /* font-family: "Agave Nerd Font", "Symbols Nerd Font"; */
        font-family: "Symbols Nerd Font";
        font-weight: bold;
        font-size: 14px;
        min-height: 0;
    }
      /* base00: "#0F1419" */
      /* base01: "#131721" */
      /* base02: "#272D38" */
      /* base03: "#3E4B59" */
      /* base04: "#BFBDB6" */
      /* base05: "#E6E1CF" */
      /* base06: "#E6E1CF" */
      /* base07: "#F3F4F5" */
      /* base08: "#F07178" */
      /* base09: "#FF8F40" */
      /* base0A: "#FFB454" */
      /* base0B: "#B8CC52" */
      /* base0C: "#95E6CB" */
      /* base0D: "#59C2FF" */
      /* base0E: "#D2A6FF" */
      /* base0F: "#E6B673" */

    window#waybar {
        background: #0F1419;
        color: #cdd6f4;
        transition: .3s;
        border-bottom: 2px solid #131721;
    }
    window#waybar.empty {
        background: rgba(21, 18, 27, 0);
    }

    window#waybar.solo {
        background: rgba(21, 18, 27, 0.719);
    }

    window#waybar.floating {
        background: rgba(21, 18, 27, 0);
    }

    tooltip {
        background: #1e1e2e;
        border-radius: 0px;
        border-width: 2px;
        border-style: solid;
        border-color: #11111b;
    }

#workspaces button {
        padding: 5px;
        color: #9c9c9c;
        margin-right: 5px;
    }

#workspaces button.active {
        color: #70e6e0;
    }

#workspaces button.focused {
        color: #a6adc8;
        background: #eba0ac;
        border-radius: 10px;
    }

#workspaces button.urgent {
        color: #11111b;
        background: #a6e3a1;
        border-radius: 10px;
    }

#workspaces button:hover {
        background: #11111b;
        border:none;
    }

#language,
#custom-hestale,
#custom-player,
#custom-caffeine,
#custom-weather,
#window,
#clock,
#battery,
#pulseaudio,
#wireplumber,
#network,
#workspaces,
#tray,
#backlight {
        transition: .4s;
        background: rgba(0, 0, 0, 0.375);
        padding: 3px 10px;
        margin: 5px 0px;
        /* line-height: 24px; */
        /* height: 24px; */
        /* margin-top: 10px; */
        color: #d2fffd;
    }

#tray {
        border-radius: 5px;
        margin-right: 10px;
    }
#tray.passive {
        background: none;
        padding: 0;
        margin: 0;
    }

#workspaces {
        border-radius: 5px;
        margin-left: 10px;
        padding-right: 0px;
        padding-left: 5px;
    }

#custom-player {
        border-radius: 5px;
        margin-left: 10px;
        margin-right:10px;
    }

#language {
        border-left: 0px;
        border-right: 0px;
        min-width:18px;
    }

#custom-hestale {
        border-left: 0px;
        border-right: 0px;
        border-radius: 5px 0px 0px 5px;
    }

#window {
        border-radius: 5px;
        margin-left: 60px;
        margin-right: 60px;
    }

#clock {
        border-radius: 5px;
        margin-left: 5px;
        border-right: 0px;
    }

#network {
        border-left: 0px;
        border-right: 0px;
    }

#pulseaudio {
        border-radius: 5px 0px 0px 5px;
        border-left: 0px;
        border-right: 0px;
    }

#wireplumber {
        border-radius: 5px 0px 0px 5px;
        border-left: 0px;
        border-right: 0px;
    }

#pulseaudio.microphone {
        border-radius:0;
    }

#battery {
        border-radius: 0 5px 5px 0;
        margin-right: 10px;
        border-left: 0px;
    }

#custom-weather {
        border-radius: 0px 5px 5px 0px;
        border-right: 0px;
        margin-left: 0px;
    } 


    window#waybar.empty #language,
    window#waybar.empty #custom-hestale,
    window#waybar.empty #custom-player,
    window#waybar.empty #custom-caffeine,
    window#waybar.empty #custom-weather,
    window#waybar.empty #window,
    window#waybar.empty #clock,
    window#waybar.empty #battery,
    window#waybar.empty #pulseaudio,
    window#waybar.empty #wireplumber,
    window#waybar.empty #network,
    window#waybar.empty #workspaces,
    window#waybar.empty #tray,
    window#waybar.empty #backlight{
        background: rgba(61, 61, 61, 0.26);
        color: #adadad;
        text-shadow: 0px 0px 1px rgb(4, 187, 187);
    }

    window#waybar.empty #window {
        background: none;
    }
    window#waybar.empty #workspaces button{
        color: #adadad;
        text-shadow: 0px 0px 1px rgb(4, 187, 187);
    }

    window#waybar.empty #workspaces button.active {
        color: #ffffff;
    }
    '';
  };
}

