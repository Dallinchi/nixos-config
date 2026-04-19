{
  flake.modules.home.shell = { pkgs, lib, ... }: {
    programs.yazi = {
      enable = true;
      package = pkgs.stable.yazi;
      shellWrapperName = "y";
    };
  };
}
