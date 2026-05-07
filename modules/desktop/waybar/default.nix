{
  flake.modules.home.waybar = {pkgs, ...}: {
    
    systemd.user.services.waybar-top = {
      Unit = {
        Description = "Waybar Top";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = ''
          ${pkgs.waybar}/bin/waybar \
            --config %h/.config/waybar/top/config.jsonc \
            --style %h/.config/waybar/top/style.css
        '';
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    systemd.user.services.waybar-bottom = {
      Unit = {
        Description = "Waybar Bottom";
        After = [ "graphical-session.target" ];
      };
      Service = {
        ExecStart = ''
          ${pkgs.waybar}/bin/waybar \
            --config %h/.config/waybar/bottom/config.jsonc \
            --style %h/.config/waybar/bottom/style.css
        '';
        Restart = "on-failure";
      };
      Install = {
        WantedBy = [ "graphical-session.target" ];
      };
    };

    xdg.configFile."waybar/top/".source = ./top;
    # xdg.configFile."waybar/top/style.css".source = ./top/style.css;

    # xdg.configFile."waybar/bottom/config.jsonc".source = ./bottom/config.jsonc;
    xdg.configFile."waybar/bottom/".source = ./bottom;
  };
}

