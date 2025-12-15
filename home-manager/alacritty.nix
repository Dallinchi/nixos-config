{ host, lib, ... }:
{
    programs.alacritty = {
    enable = true;
    settings = {

      font = lib.mkForce {
        size = 9.0;
        normal = {
          family = "Fira Code";
          style = "Regular";
        };
      };
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
#      colors = lib.mkForce {
        
	# Gotham theme 

#        primary = {
#          background = "#0c1014";
#          foreground = "#99d1ce";
#        };
#	cursor = {
#          text = "#99d1ce";
#	  background = "#d5e2f2";
#	};
#	
#	selection = {
#	  text = "#99d1ce";
#	  background = "#0a3749";
#	};
#	
#	normal = {
#	  black = "#17141e";
#	  red = "#c23127";
#	  green = "#2aa889";
#	  yellow = "#edb443";
#	  blue = "#195466";
#	  magenta = "#4e5166";
#	  cyan = "#33859e";
#	  white = "#99d1ce";
#	};
#
#	bright = {
#	  black = "#546d75";
#	  red = "#c23127";
#	  green = "#2aa889";
#	  yellow = "#edb443";
#	  blue = "#195466";
#	  magenta = "#4e5166";
#	  cyan = "#33859e";
#	  white = "#99d1ce";
#	};
#      };
    };
  };
  }
