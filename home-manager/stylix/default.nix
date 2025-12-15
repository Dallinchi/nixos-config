{ pkgs
, host
, inputs
, lib
, ...
}:
{
  imports = [
  #   inputs.stylix.nixosModules.stylix
    inputs.stylix.homeModules.stylix
  ];
  # programs.dconf.enable = true;

  stylix = {
    enable = true;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gotham.yaml";
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
 
    # gotham + auy-dark
    base16Scheme = {
      base00 = "#0c1014";
      base01 = "#131721";
      base02 = "#272D38";
      base03 = "#3E4B59";
      base04 = "#BFBDB6";
      base05 = "#E6E1CF";
      base06 = "#E6E1CF";
      base07 = "#F3F4F5";
      base08 = "#F07178";
      base09 = "#FF8F40";
      base0A = "#FFB454";
      base0B = "#B8CC52";
      base0C = "#95E6CB";
      base0D = "#59C2FF";
      base0E = "#D2A6FF";
      base0F = "#E6B673";
    };   
    
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 23;
    };

    polarity = "dark";

    targets.zen-browser.profileNames = [ "default" "darkside"];

   fonts = {
     # monospace = {
     #   package = pkgs.nerd-fonts.jetbrains-mono;
     #   name = "JetBrains Mono";
     # };
     sizes = {
       # applications = 12;
       terminal = 12;
       # desktop = 11;
       # popups = 12;
     };
   };
  };
}

