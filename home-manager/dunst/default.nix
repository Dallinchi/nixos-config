{ pkgs, lib, ... }:
{ 
  services.dunst = {
    enable = true;
       # iconTheme = {
       #   name = "Papirus-Dark";
       ##   package = pkgs.papirus-icon-theme;
       # };
        settings = {
          global = lib.mkForce{
#	    monitor = 0;
#	    follow = "mouse";
#	    width = "(0, 300)";
#	    height = "(0, 60)";
#	    origin = "top-center";
#	    offset = "10x3";
#	    notification_limit = 9;
#	    indicate_hidden = "yes";
#	    shrink = "yes";
#	    transparency = 0;
#	    notification_height = 0;
#	    separator_height = 2;
#	    padding = 8;
#	    horizontal_padding = 8;
#	    frame_width = 1;
#	    frame_color = "#00000022";
#	    separator_color = "frame";
#	    sort = "yes";
#	    idle_threshold = 120;
#
#	    # Text
#            font = "DejaVu Sans Mono 11";
#	    line_height = 0;
#	    markup = "full";
#	    format = "<b>%s</b>\n%b";
#	    alignment = "center";
#	    show_age_threshold = 60;
#	    word_wrap = "yes";
#	    ellipsize = "middle";
#	    ignore_newline = "no";
#	    stack_duplicates = "true";
#	    hide_duplicate_count = "false";
#	    show_indicators = "yes";
#
#	    # Icons
#	    icon_position = "left";
#	    max_icon_size = 32;
#
#	    # History
#	    sticky_history = "yes";
#	    history_length = 20;
#
#	    #dmenu = /usr/bin/dmenu -p dunst
#	    #browser = /usr/bin/firefox -new-tab
#
#	    always_run_script = true;
#	    title = "Dunst";
#	    class = "Dunst";
#
#	    startup_notification = false;
#	    verbosity = "mesg";
#	    corner_radius = 5;
#
#	    # Legacy
#	    force_xinerama = false;
#	    mouse_left_click = "do_action";
#	    mouse_middle_click = "close_all";
#	    mouse_right_click = "close_current";



            frame_color = "#00000022";
            separator_color = "frame";
            highlight = "#89b4fa";
            rounded = "yes";
            origin = "top-center";
            alignment = "left";
            vertical_alignment = "center";
            width = "(0, 300)";
            height = "(0, 60)";
            scale = 0;
            gap_size = 0;
            progress_bar = true;
            transparency = 5;
            text_icon_padding = 0;
            sort = "yes";
            idle_threshold = 120;
            line_height = 0;
            markup = "full";
            show_age_threshold = 60;
            ellipsize = "middle";
            ignore_newline = "no";
            stack_duplicates = true;
            sticky_history = "yes";
            history_length = 20;
            always_run_script = true;
            corner_radius = 10;
            follow = "mouse";
            font = "DejaVu Sans Mono 11";
            format = "<b>%s</b>\\n%b"; #format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\n%b"
            frame_width = 1;
            offset = "10x3";
            horizontal_padding = 10;
            icon_position = "left";
            indicate_hidden = "yes";
            min_icon_size = 0;
            max_icon_size = 32;
            mouse_left_click = "do_action, close_current";
            mouse_middle_click = "close_current";
            mouse_right_click = "close_all";
            padding = 10;
            plain_text = "no";
            separator_height = 2;
            show_indicators = "yes";
            shrink = "no";
            word_wrap = "yes";
	    force_xinerama = "false";
	    verbosity = "mesg";
            #browser = "${browser} --new-tab";
          };

 #         fullscreen_delay_everything = {fullscreen = "delay";};

          urgency_critical = lib.mkForce {
            background = "#000000AA";
            foreground = "#f5cb42";
            frame_color = "#f5cb42";
            timeout = "0";
	    icon = "${./images/notification.png}";
          };
          urgency_low = lib.mkForce {
            background = "#000000AA";
            foreground = "#dadada";
            timeout = "3";
	    frame_color = "#2c2c2c";
	    icon = "${./images/notification.png}";
          };
          urgency_normal = lib.mkForce {
            background = "#000000AA";
            foreground = "#70e6e0";
            timeout = "8";
	    frame_color = "#70e6e0";
	    icon = "${./images/notification.png}";
          };
      };
    };
}
