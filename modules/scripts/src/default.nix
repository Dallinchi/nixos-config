{
  flake.modules.nixos.scripts = {...}: {
    environment.etc."xdg/dallinchi-sfx".source = ./sfx;
  };
}
