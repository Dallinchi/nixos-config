{self, inputs, config, ...}: 
{
  flake.modules.home.zen-browser = {lib, pkgs, ...}:
  let
    defaults = import ./_firefoxSettings.nix {inherit pkgs;};
  in {
    imports = [inputs.zen-browser.homeModules.twilight];
    
    # stylix.targets.zen.enable = false;
    
    programs.zen-browser = {
      enable = true;
      inherit (defaults) policies;
      # policies = import ./policies.nix {inherit lib;};
      languagePacks = ["ru-RU"];
      profiles = {
        "whiteside" = {
          id = 0; # 0 is the default profile; see also option "isDefault"
          name = "whiteside"; # name as listed in about:profiles
          isDefault = true; # can be omitted; true if profile ID is 0
          # settings = import ./settings.nix;
          # search = import ./search.nix {};
          inherit (defaults) settings search;
          userChrome = builtins.readFile ./userChrome.css;
          # userContent = builtins.readFile ./userContent.css;
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
            ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
            ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
          '';
        };
        "darkside" = {
          id = 1; # 0 is the default profile; see also option "isDefault"
          name = "darkside"; # name as listed in about:profiles
          isDefault = false; # can be omitted; true if profile ID is 0
          # settings = import ./settings.nix;
          # search = import ./search.nix;
          inherit (defaults) settings search;
          userChrome = builtins.readFile ./userChrome.css;
          # userContent = builtins.readFile ./userContent.css;
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
            ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
            ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
          '';
        };
        "outside" = {
          id = 2; # 0 is the default profile; see also option "isDefault"
          name = "outside"; # name as listed in about:profiles
          isDefault = false; # can be omitted; true if profile ID is 0
          # settings = import ./settings.nix;
          # search = import ./search.nix;
          inherit (defaults) settings search;
          userChrome = builtins.readFile ./userChrome.css;
          # userContent = builtins.readFile ./userContent.css;
          extraConfig = ''
            ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
            ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
            ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
          '';
        };
      };
    };
  };
}
