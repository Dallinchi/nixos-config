{
  flake.modules.home.desktop = { pkgs, lib, ... }: { 
    services.easyeffects = {
      enable = true;
    };
  };
}
