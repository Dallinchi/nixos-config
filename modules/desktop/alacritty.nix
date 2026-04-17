{
  flake.modules.home.alacritty = { host, lib, ... }: {
    programs.alacritty = {
      enable = true;
      settings = {

        # font = lib.mkForce {
        #   size = 9.0;
        #   normal = {
        #     family = "Fira Code";
        #     style = "Regular";
        #   };
        # };

        cursor = {
          style = {
            shape = "Beam";
            blinking = "Always";
          };

          vi_mode_style = {
            shape = "Block";
            blinking = "On";
          };
          blink_interval = 500;
          unfocused_hollow = false;
          thickness = 0.2;
        }; 

        window = {
          padding = {
            x = 10;
            y = 10;
          };
          decorations = "none";
        };
        
      };
    };
  };
}
