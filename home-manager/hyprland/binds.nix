{ host, lib, pkgs, ... }:
let
  inherit
    (import ../../hosts/${host}/variables.nix)
    browser
    terminal
    ;
in
{
  wayland.windowManager.hyprland.settings = {
    
    gesture = [
      "3, horizontal, workspace"
      #"3, right, workspace, e-1"
    ];

    bind = [
      "$modifier, F, fullscreen"
      "$modifier, W, exec, $wallpaper"
      "$modifier, PRINT, exec, hyprshot -m region -o ~/Pictures/screenshots/"
      " 	, PRINT, exec, hyprshot -m output -o ~/Pictures/screenshots/"
      "$modifier, N, exec, [float] alacritty -t nm-wifi-menu -e nmtui"
      "$modifier, D, exec, pkill rofi || rofi -config ~/.config/rofi/config-menu.rasi -show drun"
      "$modifier, V, exec, pkill rofi || cliphist list | rofi -config ~/.config/rofi/config-cliphist.rasi -dmenu | cliphist decode | wl-copy"
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
      "$modifier, C, cyclenext"
     
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
      "$modifier SHIFT, A, layoutmsg, addmaster" 	    # master
      "$modifier SHIFT, T, layoutmsg, orientationtop"       # master
      "$modifier SHIFT, L, layoutmsg, orientationleft"      # master
      "$modifier SHIFT, R, layoutmsg, orientationright"     # master
      "$modifier SHIFT, B, layoutmsg, orientationbottom"    # master
      "$modifier SHIFT, D, layoutmsg, removemaster"	    # master
      "$modifier SHIFT, S, layoutmsg, swapwithmaster"       # master
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
      "$modifier, RETURN, exec, alacritty"
      "$modifier CTRL, C, exec, code-oss"
      "$modifier CTRL, B, exec, ${browser}"
      "$modifier CTRL, R, exec, krita"
      "$modifier CTRL, O, exec, gtk-launch obsidian"
      "$modifier CTRL, H, exec, [float] alacritty --config-file=/home/dallinchi/.config/alacritty/hestale.toml -T \"Hestale - Password Generator\" -e hestale -r"
      "$modifier CTRL, E, exec, [float] alacritty -T \"Alacritty - Ranger\" -e 'ranger'"
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
  };
}
