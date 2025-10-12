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
#    base16Scheme = lib.mkDefault {
#      base00 = "#050608";
#      base01 = "#1a1b1c";
#      base02 = "#28292a";
#      base03 = "#474849";
#      base04 = "#a3a5a6";
#      base05 = "#c1c3c4";
#      base06 = "#cfd1d2";
#      base07 = "#dddfe0";
#      base08 = "#b53b50";
#      base09 = "#ea770d";
#      base0A = "#c9d364";
#      base0B = "#09ba8b";
#      base0C = "#356394";
#      base0D = "#42fff9";
#      base0E = "#551f9c";
#      base0F = "#cd6320";
#    };
#    image = ../../wallpapers/wallhaven-1qkzkv.jpg;

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

