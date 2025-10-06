{ pkgs, lib, ... }: {
  programs.yazi = {
    enable = true;
    flavors = {
      ayu-dark = ./ayu-dark.toml;
     # inherit (pkgs.yaziPlugins) bar;
    };
  };
}
