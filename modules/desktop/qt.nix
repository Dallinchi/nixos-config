{
  flake.modules.home.desktop = { lib, ... }: {
    qt = {
      enable = true;
      # platformTheme.name = lib.mkForce "qtct";
    };
  };
}
