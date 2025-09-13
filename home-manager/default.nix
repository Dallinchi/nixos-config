{ host, ... }:

{
  imports = [
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./quickshell
    ./rofi
    ./obs-studio.nix
    ./qt.nix
    ./xdg.nix
    ./alacritty.nix
    ./packages.nix
  ];

   home.file = {
    "Pictures/Wallpapers" = {
      source = ../wallpapers;
      recursive = true;
    };
  };
}
