{
  flake.modules.nixos.nixos = {pkgs, ...}:
  {

    users = {
      mutableUsers = false;
      users = {
        
        dallinchi = {
          isNormalUser = true;
          description = "Dallinchi";
          shell = pkgs.fish;
          ignoreShellProgramCheck = true;
          extraGroups = [
            "wheel"
            "input"
            "networkmanager"
            "podman"
          ];
          
        };

      };
    };

  };
}
