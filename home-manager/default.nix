{ host, ... }:

{
  imports = [
    ./git.nix
    ./gtk.nix
    ./yazi
    ./zen
    ./fish
    ./easyeffects
    ./stylix
    ./taskwarrior
    ./zellij
    ./obs-studio.nix
    ./qt.nix
    ./xdg.nix
    ./alacritty.nix
    ./packages.nix
    ./nvchad.nix
    ./desktops
  ];

   home.file = {
    "Pictures/Wallpapers" = {
      source = ../wallpapers;
      recursive = true;
    };
  };
}
