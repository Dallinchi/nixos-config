{ host, config, lib, ... }:

let
  variables = import ../../hosts/${host}/variables.nix;
in {
# {
  imports =
    [
      # ./common.nix
    ]
    ++ lib.optional (variables.desktop == "niri") ./niri-wm
    ++ lib.optional (variables.desktop == "hyprland") ./hyprland-wm;
}
