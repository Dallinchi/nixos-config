{ host, ... }:
{
  imports = [
    ./binds.nix
    ./env.nix
    ./exec-once.nix
#    ./hypridle.nix
    ./hyprland.nix
#    ./hyprlock.nix
    ./windowrules.nix
    ./animations.nix
  ];
}
