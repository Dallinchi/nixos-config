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

        extraConfig = ''
          keybinds {
            locked {
            bind "Alt h" "Alt Left" { MoveFocusOrTab "Left"; }
            bind "Alt j" "Alt Down" { MoveFocus "Down"; }
            bind "Alt k" "Alt Up" { MoveFocus "Up"; }
            bind "Alt l" "Alt Right" { MoveFocusOrTab "Right"; }
            }
          }
        '';

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
