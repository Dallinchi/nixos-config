{
  flake.modules.home.home-manager = {
  
    programs.home-manager.enable = true;

    home.stateVersion = "25.11";
    home.pointerCursor.enable = true;

  };
}
