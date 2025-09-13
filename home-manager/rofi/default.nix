{ pkgs, lib, ... }:

{
  programs.rofi = {
        enable = true;
        package = pkgs.rofi-wayland;
        #terminal = "${getExe pkgs}";
        plugins = with pkgs; [
          rofi-emoji-wayland # https://github.com/Mange/rofi-emoji 🤯
          rofi-games # https://github.com/Rolv-Apneseth/rofi-games 🎮
        ];
      };
      xdg.configFile."rofi/config-menu.rasi".source = ./config-menu.rasi;
     # xdg.configFile."rofi/config-long.rasi".source = ./config-long.rasi;
     # xdg.configFile."rofi/config-wallpaper.rasi".source = ./config-wallpaper.rasi;
     # xdg.configFile."rofi/launchers" = {
     #   source = ./launchers;
     #   recursive = true;
     # };
      xdg.configFile."rofi/colors" = {
        source = ./colors;
        recursive = true;
      };
     # xdg.configFile."rofi/assets" = {
     #   source = ./assets;
     #   recursive = true;
     # };
     # xdg.configFile."rofi/resolution" = {
     #   source = ./resolution;
     #   recursive = true;
     # };
}
