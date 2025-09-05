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
    ./packages.nix
  ];
}
