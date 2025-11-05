{ host, ... }:

{
  imports = [
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./niri
    # ./quickshell
    ./way-edges
    ./rofi
    ./yazi
    ./zen
    ./caelestia
    ./fish
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
