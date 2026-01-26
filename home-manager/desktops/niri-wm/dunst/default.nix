{ pkgs, lib, ... }:
{ 
  services.dunst = {
    enable = true;
      # iconTheme = {
      #   name = "Papirus-Dark";
      ##   package = pkgs.papirus-icon-theme;
      # };
    settings = {
      global = lib.mkForce {

        # frame_color = "#00000022";
        separator_color = "frame";
        # highlight = "#89b4fa";
        rounded = "yes";
        origin = "bottom-right";
        alignment = "left";
        vertical_alignment = "center";
        width = "(0, 400)";
        height = "(0, 60)";
        scale = 0;
        gap_size = 0;
        progress_bar = true;
        transparency = 0;
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
        corner_radius = 5;
        follow = "mouse";
        font = "DejaVu Sans Mono 11";
        format = "<b>%s</b>\\n%b"; #format = "<span foreground='#f3f4f5'><b>%s %p</b></span>\n%b"
        frame_width = 1;
        offset = "15x15";
        horizontal_padding = 10;
        icon_position = "left";
        indicate_hidden = "yes";
        min_icon_size = 0;
        max_icon_size = 32;
        mouse_left_click = "do_action, close_current";
        mouse_middle_click = "close_current";
        mouse_right_click = "close_all";
        padding = 5;
        plain_text = "no";
        separator_height = 2;
        show_indicators = "yes";
        shrink = "no";
        word_wrap = "yes";
        force_xinerama = "false";
        verbosity = "mesg";
        #browser = "${browser} --new-tab";
      };
      urgency_critical = lib.mkForce {
        background = "#0c1014";
        foreground = "#f5cb42";
        # frame_color = "#f5cb42";
        timeout = "0";
        icon = "${./images/notification.png}";
      };
      urgency_low = lib.mkForce {
        background = "#0c1014";
        foreground = "#558cab";
        timeout = "3";
        # frame_color = "#2c2c2c";
        icon = "${./images/notification.png}";
      };
      urgency_normal = lib.mkForce {
        background = "#0c1014";
        foreground = "#d3ebe9";
        timeout = "8";
        # frame_color = "#70e6e0";
        icon = "${./images/notification.png}";
      };
    };
  };
}
