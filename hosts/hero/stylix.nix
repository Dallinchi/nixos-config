{ pkgs
, host
, inputs
, lib
, ...
}:
{
  imports = [
    inputs.stylix.nixosModules.stylix
  ];
  stylix = {
    enable = true;
    # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gotham.yaml";
  # base00: "#0c1014"
  # base01: "#11151c"
  # base02: "#091f2e"
  # base03: "#0a3749"
  # base04: "#245361"
  # base05: "#599cab"
  # base06: "#99d1ce"
  # base07: "#d3ebe9"
  # base08: "#c23127"
  # base09: "#d26937"
  # base0A: "#edb443"
  # base0B: "#33859E"
  # base0C: "#2aa889"
  # base0D: "#195466"
  # base0E: "#888ca6"
  # base0F: "#4e5166"
    cursor = {
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 23;
    };

    polarity = "dark";

#    fonts = {
#      monospace = {
#        package = pkgs.nerd-fonts.jetbrains-mono;
#        name = "JetBrains Mono";
#      };
#      sizes = {
#        applications = 12;
#        terminal = 15;
#        desktop = 11;
#        popups = 12;
#      };
#    };
  };
}

