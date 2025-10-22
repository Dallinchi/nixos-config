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
  home.packages = with pkgs; [
    grim
    slurp
    wl-clipboard
    swappy
    hyprpolkitagent
    hyprland-qtutils # needed for banners and ANR messages
  ];

  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];

  # Shell scripts
  xdg.configFile = {
    "hypr/scripts" = {
      source = ./scripts;
      recursive = true;
    };
  };

  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    xwayland = {
      enable = true;
    };

    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
      inputs.hyprland-plugins.packages.${pkgs.system}.hyprexpo
      # inputs.hyprland-plugins.packages.${pkgs.system}.hyprscrolling
    ];

    settings = {

      monitor = [
        "eDP-1, 1920x1080, 900x360, 1"
        "HDMI-A-1, 1440x900, 0x0, 1, transform, 1"
      ];        

      exec-once = [
        "wl-paste --type text --watch cliphist store" # Saves text
        "wl-paste --type image --watch cliphist store" # Saves images
        "caelestia shell -d"
        # "quickshell -c ~/.config/quickshell/lacrity-space"
        # "swaybg -i $(find ~/Pictures/Wallpapers | shuf -n 1) -m fill"
        "~/.config/hypr/scripts/monitors/orientation_keeper"
      ];

      env = [
        "NIXOS_OZONE_WL, 1"
        "NIXPKGS_ALLOW_UNFREE, 1"
        "XDG_CURRENT_DESKTOP, Hyprland"
        "XDG_SESSION_TYPE, wayland"
        "XDG_SESSION_DESKTOP, Hyprland"
        "GDK_BACKEND, wayland, x11"
        "CLUTTER_BACKEND, wayland"
        "QT_QPA_PLATFORM=wayland;xcb"
        "QT_WAYLAND_DISABLE_WINDOWDECORATION, 1"
        "QT_AUTO_SCREEN_SCALE_FACTOR, 1"
        "SDL_VIDEODRIVER, x11"
        "MOZ_ENABLE_WAYLAND, 1"
        # This is to make electron apps start in wayland
        "ELECTRON_OZONE_PLATFORM_HINT,wayland"
        # Disabling this by default as it can result in inop cfg
        # Added card2 in case this gets enabled. For better coverage
        # This is mostly needed by Hybrid laptops.
        # but if you have multiple discrete GPUs this will set order
        #"AQ_DRM_DEVICES,/dev/dri/card0:/dev/dri/card1:/dev/card2"
        "GDK_SCALE,1"
        "QT_SCALE_FACTOR,1"
        "EDITOR,nvim"
        # Set terminal and xdg_terminal_emulator to kitty
        # To provent yazi from starting xterm when run from rofi menu
        # You can set to your preferred terminal if you you like
        # ToDo: Pull default terminal from config
        "TERMINAL,alacritty"
        "XDG_TERMINAL_EMULATOR,alacritty"
      ];

      input = {
        kb_layout = "${keyboardLayout}";
        kb_options = [
          "grp:alt_shift_toggle"
        ];
        numlock_by_default = true;
        repeat_delay = 250;
      	repeat_rate = 65;
        follow_mouse = 1;
     #   float_switch_override_focus = 0;
        sensitivity = 0;
      	special_fallthrough = true;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          clickfinger_behavior = true;
          scroll_factor = 0.4;
        };
      };

      gestures = {
        workspace_swipe_distance = 500;
        workspace_swipe_invert = 1;
        workspace_swipe_min_speed_to_force = 30;
        workspace_swipe_cancel_ratio = 0.5;
        workspace_swipe_create_new = 1;
        workspace_swipe_forever = 1;
      	workspace_swipe_direction_lock = 0;
      };

      general = {
        "$modifier" = "SUPER";
        layout = "master";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 1;
        resize_on_border = true;
      	"col.active_border" = lib.mkForce "rgba(2aa889ff)";
      	#"col.active_border" = "rgba(70e6e0ff)";
    	  #"col.inactive_border" = "rgba(2f343fff)";
      };

      misc = {
        #layers_hog_keyboard_focus = true;
        #initial_workspace_tracking = 0;
        #mouse_move_enables_dpms = true;
        #key_press_enables_dpms = false;
        #disable_hyprland_logo = true;
        #disable_splash_rendering = true;
        #enable_swallow = false;
        #vfr = true; # Variable Frame Rate
        #vrr = 2; #Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0

        #  Application not responding (ANR) settings
       # enable_anr_dialog = true;
       # anr_missed_pings = 15;
      };

      decoration = {
        rounding = 10;
        #active_opacity = 0.9;
        #inactive_opacity = 0.85;
        blur = {
          enabled = false;
          size = 4;
          passes = 3;
          #ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = false;
          range = 10;
          render_power = 2;
          #color = "rgba(000214aa)";
        };
      };

      render = {
        new_render_scheduling = true;
        cm_auto_hdr = 1;
      };

      ecosystem = {
        no_donation_nag = true;
        no_update_news = false;
      };

      cursor = {
        sync_gsettings_theme = true;
        hide_on_key_press = true;
        inactive_timeout = 5;
        hotspot_padding = 3;
      };

      # Ensure Xwayland windows render at integer scale; compositor scales them
      xwayland = {
        force_zero_scaling = true;
      };

      animations = {
        enabled = true;
        bezier = [
          "md3_standard, 0.2, 0.0, 0, 1.0"
          "md3_decel, 0.05, 0.7, 0.1, 1"
          "md3_accel, 0.3, 0, 0.8, 0.15"
          "overshot, 0.05, 0.9, 0.1, 1.05"
          "hyprnostretch, 0.05, 0.9, 0.1, 1.0"
          "win10, 0, 0, 0, 0"
          "gnome, 0, 0.85, 0.3, 1"
          "funky, 0.46, 0.35, -0.2, 1.2"
        ];
        animation = [
          "windows, 1, 2, md3_standard, slide"
          "border, 1, 10, gnome"
          "fade, 1, 0.01, hyprnostretch"
          "fadeLayers, 1, 3, gnome"
          "workspaces, 1, 0.001, hyprnostretch, slidefadevert" # Хотел бы выключить, но хочется вертикальные столы при использовании тачпада
          # "workspaces, 1, 1, hyprnostretch, slidefadevert"
          "specialWorkspace, 1, 5, hyprnostretch, fade"
          "layersIn, 1, 2, md3_standard, slide"
          "layersOut, 1, 2, md3_standard, slide"
        ];
      };

      binds = {
        workspace_back_and_forth = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
        allow_small_split = true;
      };

      layerrule = [
        "blur, quickshell"
        "blur, rofi"

        # Caelestia blur
        "noanim, caelestia-(launcher|osd|notifications|border-exclusion|area-picker)"
        "animation fade, caelestia-(drawers|background)"
        "order 1, caelestia-border-exclusion"
        "order 2, caelestia-bar"
        "xray 1, caelestia-(border|launcher|bar|sidebar|navbar|mediadisplay|screencorners)"
        "blur, caelestia-.*"
        "blur, qs-.*"
        "blurpopups, caelestia-.*"
        "ignorealpha 0.57, caelestia-.*"
      #  "blur, caelestia-border-exclusion"
      #  "blur, caelestia-drawers"
      ];

      workspace = [
        # Замена no_gaps_only (В новой версии сделали гибкую систему)
        # "w[tv1]s[false], gapsout:0, gapsin:0, decorate:0"
        "w[tv1]s[false], gapsout:0, gapsin:0"
        "f[1]s[false], gapsout:0, gapsin:0"
        
        "1, monitor:eDP-1"
        "2, monitor:eDP-1"
        "3, monitor:eDP-1"
        "4, monitor:eDP-1"
        "5, monitor:eDP-1"
        "6, monitor:eDP-1"
        "7, monitor:eDP-1"
        "8, monitor:eDP-1"

        "9,  monitor:HDMI-A-1"
        "10, monitor:HDMI-A-1"
        "11, monitor:HDMI-A-1"
        "12, monitor:HDMI-A-1"
        "13, monitor:HDMI-A-1"
        "14, monitor:HDMI-A-1"
        "15, monitor:HDMI-A-1"
        "16, monitor:HDMI-A-1"	

        "special:minimized, gapsin:30, gapsout:30, layoutmsg:orientation:top, on-created-empty: pavucontrol"
      ];

      windowrule = [
        # Для окон no_gaps_only
        "bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
        "rounding 0, floating:0, onworkspace:w[tv1]s[false]"
        "bordersize 0, floating:0, onworkspace:f[1]s[false]"
        "rounding 0, floating:0, onworkspace:f[1]s[false]"

        "nodim, class:GLava)"
        "noblur, class:GLava$"

        "float, class:Electron"
        "move 5% 5%, class:Electron"
        "size 90% 90%, class:Electron"

        "float, title:Alacritty - Yazi"
        "move 5% 5%, title:Alacritty - Yazi"
        "size 90% 90%, title:Alacritty - Yazi"

        "workspace 1, class:firefox, floating:0"
        "nodim, class:firefox"
        "float, class:firefox), title:Картинка в картинке)"

        "workspace 1, class:zen-twilight, floating:0"
        "nodim, class:zen-twilight"
        "float, class:zen-twilight), title:Картинка в картинке)"

        "workspace 1, class:waterfox, floating:0"
        "nodim, class:waterfox"
        "float, class:waterfox), title:Картинка в картинке)"

        "nodim, class:Alacritty"
        # noblur, class:Alacritty"

        "workspace 4, class:Spotify"
        "workspace 4, class:yandex-music"
        "workspace 4, class:org.pulseaudio.pavucontrol"
        "workspace 4, class:com.github.wwmm.easyeffects"

        "workspace 6, class:steam"

        "workspace 3, class:Code - OSS"
        "workspace 3, class:jetbrains-idea-ce"

        "nodim, class:jetbrains-idea-ce"

        "workspace 5, title:(Telegram)(.*), class:org.telegram.desktop"
        "float, title:Просмотр медиа, class:org.telegram.desktop"
        "move 0% 0%, title:Просмотр медиа, class:org.telegram.desktop"
        "size 100% 100%, title:Просмотр медиа, class:org.telegram.desktop"
        "noborder, title:Просмотр медиа, class:org.telegram.desktop"
        "rounding 0, title:Просмотр медиа, class:org.telegram.desktop"

        "workspace 5, class:discord"
        "move 5% 5%, class:discord"
        "size 90% 90%, class:discord"

        "workspace 4, class:yandex-music"

        "float,class:mpv"
        "move 5% 5%, class:mpv"
        "size 90% 90%, class:mpv"

        "float, class:Nsxiv"
        "move 5% 5%, class:Nsxiv"
        "size 90% 90%, class:Nsxiv"

        "float,class:io.github.alainm23.planify"
        "size 500 900, class:io.github.alainm23.planify"

        "float,class:obsidian"
        "move 5% 5%, class:obsidian"
        "size 90% 90%, class:obsidian"

        "workspace 15, class:koodo-reader"
        "float,class:koodo-reader"
        "nodim, class:koodo-reader"
        "move 5% 5%, class:koodo-reader"
        "size 90% 90%, class:koodo-reader"

        "workspace 6, class:lutris"
        "float, class:lutris"
        "move 5% 5%, class:lutris"
        "size 90% 90%, class:lutris"

        "workspace 8, class:com.seafile.seafile-applet"
        "float, class:com.seafile.seafile-applet"
        "move 5% 5%, class:com.seafile.seafile-applet"
        "size 90% 90%, class:com.seafile.seafile-applet"

        "workspace 8, class:org.gnome.Nautilus"
        "float, class:org.gnome.Nautilus"
        "move 5% 5%, class:org.gnome.Nautilus"
        "size 90% 90%, class:org.gnome.Nautilus"

        "float,class:org.kde.ark"
        "float,class:com.github.rafostar.Clapper" #Clapper-Gtk
        "float,class:app.drey.Warp" #Warp-Gtk
        "float,class:net.davidotek.pupgui2" #ProtonUp-Qt
        "float,class:yad" #Protontricks-Gtk
        "float,class:pavucontrol"
        "float,class:blueman-manager"
        "float,class:nm-applet"
        "float,class:nm-connection-editor"
        "float,class:lxqt-policykit-agent"
      ];

      gesture = [
        "3, vertical, workspace"
        #"3, right, workspace, e-1"
      ];

      bind = [
        "$modifier, F, fullscreen"
        "$modifier, A, fullscreen, 1" 
        "$modifier, W, exec, $wallpaper"
        "$modifier, PRINT, exec, hyprshot -m region -o ~/Pictures/screenshots/"
        " 	, PRINT, exec, hyprshot -m output -o ~/Pictures/screenshots/"
        "$modifier, N, exec, [float] alacritty -t nm-wifi-menu -e nmtui"
        "$modifier, D, exec, pkill rofi || rofi -config ~/.config/rofi/config-menu.rasi -show drun -monitor eDP-1"
        # "$modifier, D, exec, caelestia shell drawers toggle launcher"
        "$modifier, V, exec, pkill rofi || cliphist list | rofi -config ~/.config/rofi/config-cliphist.rasi -dmenu -monitor eDP-1 | cliphist decode | wl-copy"
        "$modifier, I, exec, caelestia shell drawers toggle sidebar"
        "$modifier, E, exec, hyprctl dispatch hyprexpo:expo toggle"
        "$modifier, F1, exec, ~/.config/hypr/scripts/gamemode"
        "$modifier, F2, exec, ~/.config/hypr/scripts/monitors/toggle_mouselock_monitor"
        
        # Переключение на другой воркспейс скролом мыши с зажатым $modifier
        "$modifier, mouse_down, workspace, e+1"
        "$modifier, mouse_up, workspace, e-1"

        # Управлени фокусом
        "$modifier, H, movefocus, l"
        "$modifier, L, movefocus, r"
        "$modifier, K, movefocus, u"
        "$modifier, J, movefocus, d"
        
        # "$modifier, H, layoutmsg, move -col"
        # "$modifier, L, layoutmsg, move +col"
        # "$modifier, K, movefocus, u"
        # "$modifier, J, movefocus, d"

        "$modifier, C, cyclenext"
        "$modifier, R, focusmonitor, +1"

        "$modifier, equal, exec, hyprctl keyword cursor:zoom_factor $(awk \"BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') + 0.5}\")"
        "$modifier, minus, exec, hyprctl keyword cursor:zoom_factor $(awk \"BEGIN {print $(hyprctl getoption cursor:zoom_factor | grep 'float:' | awk '{print $2}') - 0.5}\")"

        # Переключение воркспейсов
        "$modifier, 1, exec, ~/.config/hypr/scripts/toworkspace 1 8"
        "$modifier, 2, exec, ~/.config/hypr/scripts/toworkspace 2 8"
        "$modifier, 3, exec, ~/.config/hypr/scripts/toworkspace 3 8"
        "$modifier, 4, exec, ~/.config/hypr/scripts/toworkspace 4 8"
        "$modifier, 5, exec, ~/.config/hypr/scripts/toworkspace 5 8"
        "$modifier, 6, exec, ~/.config/hypr/scripts/toworkspace 6 8"
        "$modifier, 7, exec, ~/.config/hypr/scripts/toworkspace 7 8"
        "$modifier, 8, exec, ~/.config/hypr/scripts/toworkspace 8 8"
   
        # Перемещение окна между мониторами
        "$modifier CTRL, 1, movetoworkspace, -8"
        "$modifier CTRL, 2, movetoworkspace, +8"
        
        # Специальный воркспейс для свернутых приложений
        "$modifier, TAB, togglespecialworkspace, minimized"

        # Сворачивание окна
        "$modifier SHIFT, TAB, movetoworkspace, special:minimized"
        "$modifier SHIFT, TAB, togglespecialworkspace, minimized"

        # Разворачние окна
        "$modifier CTRL, TAB, movetoworkspace, +0"

        # Управление layout
        "$modifier SHIFT, A, layoutmsg, addmaster" 	          # master
        "$modifier SHIFT, T, layoutmsg, orientationtop"       # master
        "$modifier SHIFT, L, layoutmsg, orientationleft"      # master
        "$modifier SHIFT, R, layoutmsg, orientationright"     # master
        "$modifier SHIFT, B, layoutmsg, orientationbottom"    # master
        "$modifier SHIFT, D, layoutmsg, removemaster"	        # master
        "$modifier SHIFT, S, layoutmsg, swapwithmaster"       # master

        # "$modifier, minus, layoutmsg, colresize -conf"        # scrolling
        # "$modifier, equal, layoutmsg, colresize +conf"        # scrolling
        # "$modifier SHIFT, A, layoutmsg, togglefit" 	          # scrolling
        # "$modifier SHIFT, T, layoutmsg, promote"              # scrolling
        # "$modifier SHIFT, S, layoutmsg, swapcol r"            # scrolling
        # "$modifier SHIFT, F, layoutmsg, fit active"	          # scrolling
        # "$modifier SHIFT, D, layoutmsg, fit all"	            # scrolling
        #
        "$modifier SHIFT, SPACE, togglefloating"
        "$modifier SHIFT, P, pin"
        "$modifier SHIFT, Q, killactive," 

        # Перемещение окна на другой воркспейс
        "$modifier SHIFT, 1, split-movetoworkspace, 1"
        "$modifier SHIFT, 2, split-movetoworkspace, 2"
        "$modifier SHIFT, 3, split-movetoworkspace, 3"
        "$modifier SHIFT, 4, split-movetoworkspace, 4"
        "$modifier SHIFT, 5, split-movetoworkspace, 5"
        "$modifier SHIFT, 6, split-movetoworkspace, 6"
        "$modifier SHIFT, 7, split-movetoworkspace, 7"
        "$modifier SHIFT, 8, split-movetoworkspace, 8"
       
        # Поворот второго монитора
        "$modifier SHIFT, V, exec, ~/.config/hypr/scripts/monitors/orientation_keeper 1"
        "$modifier SHIFT, H, exec, ~/.config/hypr/scripts/monitors/orientation_keeper 0"

        # Ресайз
        "$modifier SHIFT, left, resizeactive,-50 0"
        "$modifier SHIFT, right, resizeactive,50 0"
        "$modifier SHIFT, up, resizeactive,0 -50"
        "$modifier SHIFT, down, resizeactive,0 50"

        # Запуск софта
        "$modifier, RETURN, exec, ~/.config/hypr/scripts/execonmonitor 2 alacritty"
        # "$modifier, RETURN, exec, alacritty"
        "$modifier CTRL, C, exec, code-oss"
        "$modifier CTRL, B, exec, zen-twilight"
        "$modifier CTRL, R, exec, krita"
        "$modifier CTRL, O, exec, gtk-launch obsidian"
        "$modifier CTRL, H, exec, [float] alacritty --config-file=/home/dallinchi/.config/alacritty/hestale.toml -T \"Hestale - Password Generator\" -e hestale -r"
        "$modifier CTRL, E, exec, [float] alacritty -T \"Alacritty - Yazi\" -e 'yazi'"
        "$modifier CTRL, V, exec, [workspace special:minimized] alacritty -e /home/dallinchi/Documents/vpns/OpenConnect/connect"
        "$modifier CTRL, P, exec, python ~/Code/Projects/cli-timer-delay -r -a 'alert' -d 40"
        "$modifier CTRL, M, exec, yandex-music"
        "$modifier CTRL, T, exec, telegram-desktop"
        "$modifier CTRL, D, exec, gtk-launch Discord"
        "$modifier CTRL, K, exec, koodo-reader"
        "$modifier CTRL, I, exec, ~/.config/hypr/scripts/bar-toggle"
        "$modifier CTRL, PRINT, exec, [float] alacritty -e \"make-screencast\""

        # Категории нет. Прикольные штуксы?
        "$modifier ALT, N, exec, playerctl next"
        "$modifier ALT, P, exec, playerctl previous" 
        "$modifier ALT, K, exec, playerctl play-pause" 

        # Спец-клавиши
        ", XF86AudioRaiseVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86AudioMicMute, exec, pactl set-source-mute @DEFAULT_SOURCE@ toggle"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl set 5%+"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86Search, exec, bemenu-run"
      ];
   
      # Блокировка перехода курсора на второй монитор
#    binds = [
#      "Super_L, M&L, exec, ~/.config/hypr/scripts/monitors/toggle_mouselock_monitor"
#    ];

      bindm = [
        "$modifier, mouse:272, movewindow"
        "$modifier, mouse:273, resizewindow"
      ];

      plugin = {
        split-monitor-workspaces = {
          count = 8;
          keep_focused = true;
          enable_notification = false;
          enable_persistent_workspaces = false;
        };
        
        hyprexpo = {
          columns = 3;
          gap_size = 5;
          bg_col = "rgb(111111)";
          workspace_method = "first 1";
          skip_empty = false;
          enable_gesture = true;
          gesture_fingers = 3;
          gesture_distance = 300;
          gesture_positive = true;
        };

        # hyprscrolling = {
        #   # column_default_width = "onehalf";
        #   # column_widths = "onehalf one";
        #   fullscreen_on_one_column = true;
        #   focus_fit_method = 1;
        #   follow_focus = true;
        # };
      };
    };
  };
}
