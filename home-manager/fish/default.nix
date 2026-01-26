{ pkgs, lib, ... }:

{
  programs = {
    fish = {
      enable = true;
      
      functions.boop = ''
        set last $status
        if test $last -eq 0
            sfx good
        else
            sfx bad
        end
        return $last
      '';

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

