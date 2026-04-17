{
  flake.modules.home.shell = {config, lib, ...}: {
    programs = {
      zellij = {
        enable = true;
        enableFishIntegration = true;

        settings = {
          theme_dir = "${config.xdg.configHome}/zellij/themes";

          show_startup_tips = false;
          default_layout = "compact";
        };

        themes.stylix = {
          themes = with config.lib.stylix.colors.withHashtag; {
            default = {
              ribbon_selected = {
                background = lib.mkForce base0C;
              };
              table_title = {
                base = lib.mkForce base0C;
              };
              frame_selected = {
                base = lib.mkForce base0C;
              };
            };
          };
        };
      };
    };
  };
}
