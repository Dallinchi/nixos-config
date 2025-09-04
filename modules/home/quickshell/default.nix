{ config, pkgs, inputs, lib, ... }:

{
  # Configuration files
  xdg.configFile = {
    # Main caelestia shell configuration
    "quickshell/lacrity-space" = {
      source = ./shell;
      recursive = true;
    };
  };
}
