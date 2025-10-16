{host, ...}:

{
  wayland.windowManager.hyprland = {
    settings = {


	workspace = [
	# Замена no_gaps_only (В новой версии сделали гибкую систему)
	"w[tv1]s[false], gapsout:0, gapsin:0, decorate:0"
	"f[1]s[false], gapsout:0, gapsin:0"
	
	"1, monitor:eDP-1"
	"2, monitor:eDP-1"
	"3, monitor:eDP-1"
	"4, monitor:eDP-1"
	"5, monitor:eDP-1"
	"6, monitor:eDP-1"
	"7, monitor:eDP-1"
	"8, monitor:eDP-1"

	"9,  monitor:HDMI-A-1"
	"10, monitor:HDMI-A-1"
	"11, monitor:HDMI-A-1"
	"12, monitor:HDMI-A-1"
	"13, monitor:HDMI-A-1"
	"14, monitor:HDMI-A-1"
	"15, monitor:HDMI-A-1"
	"16, monitor:HDMI-A-1"	

	"special:minimized, gapsin:30, gapsout:30, layoutmsg:orientation:top, on-created-empty: pavucontrol"
	];

    windowrule = [
  # Для окон no_gaps_only
	"bordersize 0, floating:0, onworkspace:w[tv1]s[false]"
	"rounding 0, floating:0, onworkspace:w[tv1]s[false]"
	"bordersize 0, floating:0, onworkspace:f[1]s[false]"
	"rounding 0, floating:0, onworkspace:f[1]s[false]"

	"nodim, class:GLava)"
	"noblur, class:GLava$"

	"float, class:Electron"
	"move 5% 5%, class:Electron"
	"size 90% 90%, class:Electron"

	"float, title:Alacritty - Yazi"
	"move 5% 5%, title:Alacritty - Yazi"
	"size 90% 90%, title:Alacritty - Yazi"

	"workspace 1, class:firefox, floating:0"
	"nodim, class:firefox"
	"float, class:firefox), title:Картинка в картинке)"

	"workspace 1, class:zen-twilight, floating:0"
	"nodim, class:zen-twilight"
	"float, class:zen-twilight), title:Картинка в картинке)"

	"workspace 1, class:waterfox, floating:0"
	"nodim, class:waterfox"
	"float, class:waterfox), title:Картинка в картинке)"

	"nodim, class:Alacritty"
	# noblur, class:Alacritty"

	"workspace 4, class:Spotify"
	"workspace 4, class:yandex-music"
	"workspace 4, class:org.pulseaudio.pavucontrol"
	"workspace 4, class:com.github.wwmm.easyeffects"

	"workspace 6, class:steam"

	"workspace 3, class:Code - OSS"
	"workspace 3, class:jetbrains-idea-ce"

	"nodim, class:jetbrains-idea-ce"

	"workspace 5, title:(Telegram)(.*), class:org.telegram.desktop"
	"float, title:Просмотр медиа, class:org.telegram.desktop"
	"move 0% 0%, title:Просмотр медиа, class:org.telegram.desktop"
	"size 100% 100%, title:Просмотр медиа, class:org.telegram.desktop"
	"noborder, title:Просмотр медиа, class:org.telegram.desktop"
	"rounding 0, title:Просмотр медиа, class:org.telegram.desktop"

	"workspace 5, class:discord"
	"move 5% 5%, class:discord"
	"size 90% 90%, class:discord"

	"workspace 4, class:yandex-music"

	"float,class:mpv"
	"move 5% 5%, class:mpv"
	"size 90% 90%, class:mpv"

	"float, class:Nsxiv"
	"move 5% 5%, class:Nsxiv"
	"size 90% 90%, class:Nsxiv"

	"float,class:io.github.alainm23.planify"
	"size 500 900, class:io.github.alainm23.planify"

	"float,class:obsidian"
	"move 5% 5%, class:obsidian"
	"size 90% 90%, class:obsidian"

	"workspace 15, class:koodo-reader"
	"float,class:koodo-reader"
	"nodim, class:koodo-reader"
	"move 5% 5%, class:koodo-reader"
	"size 90% 90%, class:koodo-reader"

	"workspace 6, class:lutris"
	"float, class:lutris"
	"move 5% 5%, class:lutris"
	"size 90% 90%, class:lutris"

	"workspace 8, class:com.seafile.seafile-applet"
	"float, class:com.seafile.seafile-applet"
	"move 5% 5%, class:com.seafile.seafile-applet"
	"size 90% 90%, class:com.seafile.seafile-applet"

	"workspace 8, class:org.gnome.Nautilus"
	"float, class:org.gnome.Nautilus"
	"move 5% 5%, class:org.gnome.Nautilus"
	"size 90% 90%, class:org.gnome.Nautilus"


	# "opacity 0.90 0.90,class:Alacritty"
	# "opacity 0.90 0.90,class:Vivaldi-stable"
	# "opacity 0.85 0.85,class:firefox"
	# "opacity 0.85 0.85,class:zen-twilight"
	# "opacity 0.95 0.95,class:waterfox"
	# "opacity 0.80 0.80,class:Steam"
	# "opacity 0.80 0.80,class:steam"
	# "opacity 0.80 0.80,class:steamwebhelper"
	# "opacity 0.70 0.70,class:Spotify"
	# "opacity 0.70 0.70,class:yandex-music"
	# "opacity 0.90 0.90,class:Code - OSS"
	# "opacity 0.90 0.90,class:jetbrains-idea-ce"
	# "opacity 0.80 0.80,class:kitty"
	# "opacity 0.80 0.80,class:org.kde.dolphin"
	# "opacity 0.80 0.80,class:org.gnome.Nautilus"
	# "opacity 0.80 0.80,class:org.kde.ark"
	# "opacity 0.80 0.80,class:nwg-look"
	# "opacity 0.80 0.80,class:qt5ct"
	# "opacity 0.80 0.80,class:org.telegram.desktop"
	#
	# "opacity 0.90 0.90,class:com.github.rafostar.Clapper" #Clapper-Gtk
	# "opacity 0.80 0.80,class:com.github.tchx84.Flatseal" #Flatseal-Gtk
	# "opacity 0.80 0.8:0,class:hu.kramo.Cartridges" #Cartridges-Gtk
	# "opacity 0.80 0.80,class:com.obsproject.Studio" #Obs-Qt
	# "opacity 0.80 0.80,class:gnome-boxes" #Boxes-Gtk
	# "opacity 0.80 0.80,class:discord" #Discord-Electron
	# "opacity 0.80 0.80,class:WebCord" #WebCord-Electron
	# "opacity 0.80 0.80,class:app.drey.Warp" #Warp-Gtk
	# "opacity 0.80 0.80,class:net.davidotek.pupgui2" #ProtonUp-Qt
	# "opacity 0.80 0.80,class:yad" #Protontricks-Gtk
	# "opacity 0.80 0.80,class:koodo-reader"
	#
	# "opacity 0.80 0.70,class:pavucontrol"
	# "opacity 0.80 0.70,class:blueman-manager"
	# "opacity 0.80 0.70,class:nm-applet"
	# "opacity 0.80 0.70,class:nm-connection-editor"
	# "opacity 0.80 0.70,class:lxqt-policykit-agent"
	# "opacity 1 1,class:vlc"

	"float,class:org.kde.ark"
	"float,class:com.github.rafostar.Clapper" #Clapper-Gtk
	"float,class:app.drey.Warp" #Warp-Gtk
	"float,class:net.davidotek.pupgui2" #ProtonUp-Qt
	"float,class:yad" #Protontricks-Gtk
	"float,class:pavucontrol"
	"float,class:blueman-manager"
	"float,class:nm-applet"
	"float,class:nm-connection-editor"
	"float,class:lxqt-policykit-agent"
      ];
    };
  };
}
