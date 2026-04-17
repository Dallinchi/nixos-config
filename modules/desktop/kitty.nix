{
  flake.modules.home.kitty = { host, lib, ... }: {
    programs.kitty = {
      enable = true;
      settings = {
        
        cursor_trail = 3;
        cursor_blink_interval = 0.8; 
        # font = lib.mkForce {
        #   size = 9.0;
        #   normal = {
        #     family = "Fira Code";
        #     style = "Regular";
        #   };
        # };

        # cursor = {
        #   style = {
        #     shape = "Beam";
        #     blinking = "Always";
        #   };
        #
        #   vi_mode_style = {
        #     shape = "Block";
        #     blinking = "On";
        #   };
        #   blink_interval = 500;
        #   unfocused_hollow = false;
        #   thickness = 0.2;
        # }; 
        #
        # window = {
        #   padding = {
        #     x = 10;
        #     y = 10;
        #   };
        #   decorations = "none";
        # };
        
      };
    };
  };
}
