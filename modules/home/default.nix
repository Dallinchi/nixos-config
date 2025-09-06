{ host, ... }:

{
  imports = [
    ./git.nix
    ./gtk.nix
    ./hyprland
    ./quickshell
    ./obs-studio.nix
    ./qt.nix
    ./xdg.nix
    ./alacritty.nix
    ./packages.nix
    ./steam.nix
  ];

   home.file = {
    "Pictures/Wallpapers" = {
      source = ../../wallpapers;
      recursive = true;
    };
  };
}
