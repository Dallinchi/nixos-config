{ host, ... }:

{
  imports = [
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./niri
    # ./mango
    # ./quickshell
    ./way-edges
    ./waybar
    ./rofi
    ./yazi
    ./zen
    ./caelestia
    ./fish
    ./swayosd
    ./easyeffects
    ./obs-studio.nix
    ./qt.nix
    ./xdg.nix
    ./alacritty.nix
    ./packages.nix
    ./dunst
    ./nvchad.nix
  ];

   home.file = {
    "Pictures/Wallpapers" = {
      source = ../wallpapers;
      recursive = true;
    };
  };
}
