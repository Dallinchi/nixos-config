{ host, ... }:
{
  imports = [
    ./binds.nix
    ./env.nix
    ./exec-once.nix
    ./hyprland.nix
    ./windowrules.nix
    ./animations.nix
  ];
}
