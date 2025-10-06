{
  inputs,
  lib,
  pkgs,
  ...
}: {
  imports = [inputs.zen-browser.homeModules.twilight];

  programs.zen-browser = {
    enable = true;
    policies = import ./policies.nix {inherit lib;};
    languagePacks = ["ru-RU"];
    profiles = {
      default = {
        id = 0; # 0 is the default profile; see also option "isDefault"
        name = "default"; # name as listed in about:profiles
        isDefault = true; # can be omitted; true if profile ID is 0
        settings = import ./settings.nix;
        search = import ./search.nix {inherit pkgs;};
        userChrome = builtins.readFile ./userChrome.css;
        userContent = builtins.readFile ./userContent.css;
        extraConfig = ''
          ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
          ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
          ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
          ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
        '';
      };
      darkside = {
        id = 1; # 0 is the default profile; see also option "isDefault"
        name = "darkside"; # name as listed in about:profiles
        isDefault = false; # can be omitted; true if profile ID is 0
        settings = import ./settings.nix;
        search = import ./search.nix {inherit pkgs;};
        userChrome = builtins.readFile ./userChrome.css;
        userContent = builtins.readFile ./userContent.css;
        extraConfig = ''
          ${builtins.readFile "${inputs.betterfox}/Fastfox.js"}
          ${builtins.readFile "${inputs.betterfox}/Peskyfox.js"}
          ${builtins.readFile "${inputs.betterfox}/Securefox.js"}
          ${builtins.readFile "${inputs.betterfox}/Smoothfox.js"}
        '';
      };
    };
  };
}
