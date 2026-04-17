{self, inputs, ...}: 
let
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
in 
{
  flake.modules.home.stylix = {pkgs, ...}: {

    imports = [
      inputs.stylix.homeModules.stylix
    ];

    stylix = {
      inherit base16Scheme;
      enable = true;
      
      cursor = {
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 23;
      };

      polarity = "dark";

    };
  };

  flake.modules.nixos.stylix = {...}: {

    imports = [
      inputs.stylix.nixosModules.stylix
    ];

    stylix = {
      inherit base16Scheme;
      enable = true;
   
      polarity = "dark";
    };
  };
}


