{
  flake.modules.nixos.shell = {
    programs.nh = {
      enable = true;
      clean.enable = true;
      clean.extraArgs = "--keep-since 7d --keep 3";
      flake = "/home/dallinchi/Desktop/AeternumOS"; # sets NH_OS_FLAKE variable for you
    };
  };
}
