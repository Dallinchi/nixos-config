{
  flake.modules.home.discord = {
    programs.discord = {
      enable = true;
      settings.SKIP_HOST_UPDATE = true;
    };
  };
}

