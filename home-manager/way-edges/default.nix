{ host
, config
, pkgs
, inputs
, lib
, ...
}:
{
	imports = [
		inputs.way-edges.homeManagerModules.default
	];

  programs.way-edges = {
    enable = true;

    settings = {
      "$schema" = "./schema.json";
      widgets = [
        {
          type = "wrap-box";
          edge = "top";
          gap = 30;
          items = [
            {
              "fg-color" = "#FFFFFF";
              "font-family" = "serif";
              "font-size" = 15;
              preset = {
                format = "%-d %B | %A | %H:%M";
                type = "time";
                "update-interval" = 500;
              };
              type = "text";
            }
          ];
          layer = "top";
          outlook = {
            type = "window";
            "border-width" = 2;
            "border-radius" = 5;
            color = "#222222";
            margins = {
              bottom = 2;
              left = 10;
              right = 10;
              top = 4;
            };
          };
          monitor = "eDP-1";
          namespace = "time";
          position = "right";
          "preview-size" = "100%";
        }

        {
          "bg-color" = "#0000";
          "bg-text-color" = "#fffa";
          "border-color" = "#222222";
          "border-width" = 1;
          edge = "top";
          "fg-color" = "#222222";
          "fg-text-color" = "#fffa";
          "font-family" = "serif";
          layer = "top";
          length = "20%";
          monitor = "*";
          "obtuse-angle" = 90;
          position = "left";
          preset = { type = "speaker"; };
          "preview-size" = "100%";
          radius = 0;
          "redraw-only-on-internal-update" = true;
          thickness = 25;
          type = "slider";
        }

        {
          # other basic configs omitted in original JSON — reproduced only provided fields
          type = "wrap-box";
          "preview-size" = "100%";
          items = [
            {
              # index = [-1 -1];
              type = "tray";
              "font-family" = "monospace";
              "grid-align" = "bottom-center";
              "icon-theme" = "breeze";
              "icon-size" = 20;
              "tray-gap" = 2;
              "header-draw-config" = {
                "text-color" = "#00000000";
                "font-pixel-height" = 20;
              };
              "header-menu-align" = "right";
              "header-menu-stack" = "menu-top";
              "menu-draw-config" = {
                "border-color" = "#00000000";
                "text-color" = "#00000000";
                "marker-color" = "#00000000";
                "font-pixel-height" = 22;
                "icon-size" = 20;
                "marker-size" = 20;
                "separator-height" = 5;
                margin = [ 12 12 ];
              };
            }
          ];
        }
      ];
    };
  };
}
