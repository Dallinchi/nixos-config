{ host
, config
, pkgs
, inputs
, ...
}:
let
  inherit
    (import ../../hosts/${host}/variables.nix)
    extraMonitorSettings
    keyboardLayout
#    stylixImage
    ;
in
{
  home.packages = with pkgs; [
#    swww
    grim
    slurp
    wl-clipboard
 #   swappy
 #   ydotool
    hyprpolkitagent
    hyprland-qtutils # needed for banners and ANR messages
  ];
  systemd.user.targets.hyprland-session.Unit.Wants = [
    "xdg-desktop-autostart.target"
  ];
  # Place Files Inside Home Directory
#  home.file = {
#    "Pictures/Wallpapers" = {
#      source = ../../../wallpapers;
#      recursive = true;
#    };
#    ".face.icon".source = ./face.jpg;
#    ".config/face.jpg".source = ./face.jpg;
#  };
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    systemd = {
      enable = true;
      enableXdgAutostart = true;
      variables = [ "--all" ];
    };
    xwayland = {
      enable = true;
    };
    plugins = [
      inputs.split-monitor-workspaces.packages.${pkgs.system}.split-monitor-workspaces
    ];
    settings = {
      plugin = {
        split-monitor-workspaces = {
	  count = 8;
	  keep_focused = true;
	  enable_notification = false;
	  enable_persistent_workspaces = false;
	};
      };
      input = {
        kb_layout = "${keyboardLayout}";
        kb_options = [
          "grp:alt_shift_toggle"
        ];
        numlock_by_default = true;
        repeat_delay = 250;
	repeat_rate = 60;
        follow_mouse = 1;
        float_switch_override_focus = 0;
        sensitivity = 0;
	special_fallthrough = true;
        touchpad = {
          natural_scroll = true;
          disable_while_typing = true;
          scroll_factor = 0.8;
        };
      };

#      gestures = {
#        #workspace_swipe = 1;
#	workspace_swipe_touch = true;
#        #workspace_swipe_fingers = 3;
#        workspace_swipe_distance = 500;
#        workspace_swipe_invert = 1;
#        workspace_swipe_min_speed_to_force = 30;
#        workspace_swipe_cancel_ratio = 0.5;
#        workspace_swipe_create_new = 1;
#        workspace_swipe_forever = 1;
#      };

      general = {
        "$modifier" = "SUPER";
        layout = "master";
        gaps_in = 6;
        gaps_out = 8;
        border_size = 1;
        resize_on_border = true;
	"col.active_border" = "rgba(70e6e0ff)";
    	"col.inactive_border" = "rgba(2f343fff)";
      };

      misc = {
        #layers_hog_keyboard_focus = true;
        #initial_workspace_tracking = 0;
        #mouse_move_enables_dpms = true;
        #key_press_enables_dpms = false;
        #disable_hyprland_logo = true;
        #disable_splash_rendering = true;
        #enable_swallow = false;
        #vfr = true; # Variable Frame Rate
        #vrr = 2; #Variable Refresh Rate  Might need to set to 0 for NVIDIA/AQ_DRM_DEVICES
        # Screen flashing to black momentarily or going black when app is fullscreen
        # Try setting vrr to 0

        #  Application not responding (ANR) settings
       # enable_anr_dialog = true;
       # anr_missed_pings = 15;
      };
      binds = {
        workspace_back_and_forth = true;
      };
      dwindle = {
        pseudotile = true;
        preserve_split = true;
        force_split = 2;
      };

      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 4;
          passes = 3;
          #ignore_opacity = false;
          new_optimizations = true;
        };
        shadow = {
          enabled = true;
          range = 10;
          render_power = 2;
          color = "rgba(000214aa)";
        };
      };

      ecosystem = {
        no_donation_nag = true;
        no_update_news = false;
      };

      cursor = {
        sync_gsettings_theme = true;
        no_hardware_cursors = 2; # change to 1 if want to disable
        enable_hyprcursor = false;
        warp_on_change_workspace = 2;
        no_warps = true;
      };

      render = {
        # Disabling as no longer supported
        #explicit_sync = 1; # Change to 1 to disable
        #explicit_sync_kms = 1;
        direct_scanout = 0;
      };

      master = {
        new_status = "master";
        new_on_top = 1;
        mfact = 0.5;
      };

      # Ensure Xwayland windows render at integer scale; compositor scales them
      xwayland = {
        force_zero_scaling = true;
      };

      layerrule = [
       "blur, quickshell"
      ];
    };


    extraConfig = "
      monitor=eDP-1, 1920x1080,900x360,1
      monitor=HDMI-A-1,1440x900,0x0,1,transform,1
    ";
  };
}
