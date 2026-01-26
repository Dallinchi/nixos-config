{ pkgs, lib, ... }:

{
  services.swayosd = {
        enable = true;
        # package = pkgs.swayosd;
  };

  xdg.configFile."swayosd/style.css".source = ./style.css;
  xdg.configFile."swayosd/config.toml".source = ./config.toml;
}
