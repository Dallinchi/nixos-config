{ pkgs, lib, ... }:

{
  programs = {
    fish = {
      enable = true;
      
      interactiveShellInit = ''
        set fish_greeting # Disable greeting
      '';
      
      loginShellInit = ''
        starship init fish | source;
        direnv hook fish | source;
      '';
      };

    direnv.enable = true;
    starship = {
      enable = true;
      enableFishIntegration = true;
    };
  };
}

