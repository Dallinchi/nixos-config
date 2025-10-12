{ inputs, pkgs, ... }:
{
	imports = [
		inputs.caelestia-shell.homeManagerModules.default
	];

	programs.caelestia = {
		enable = true;
	
		systemd = {
			enable = true;
			target = "graphical-session.target";
			environment = [];
		};

		cli = {
			enable = true;
	
			settings.theme.enableGtk = true;
		};
	
		settings = {
      appearance = {
        transparency = {
          enabled = false;
          base = 0.9;
          layers = 0.9;
        };
      };

			general = {
				apps = {
					terminal = [ "alacritty" ];
					audio = [ "pavucontrol" ];
					explorer = [ "thunar" ];
				};
			};

			background = {
				enabled = true;

				desktopClock = {
					enabled = false;
				};

				visualizer = {
					enabled = false;

					autoHide = true;
					rounding = 1;
					spacing = 1;
				};
			};

			bar = {
				persistent = true;
				showOnHover = true;
        
        entries = [
          {
            id = "logo";
            enabled = true;
          }
          {
            id = "workspaces";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "activeWindow";
            enabled = true;
          }
          {
            id = "spacer";
            enabled = true;
          }
          {
            id = "tray";
            enabled = true;
          }
          {
            id = "clock";
            enabled = true;
          }
          {
            id = "statusIcons";
            enabled = true;
          }
          {
            id = "power";
            enabled = true;
          }
        ];

				dragThreshold = 20;

				workspaces = {
					activeIndicator = true;
					activeLabel = "󰮯 ";
					activeTrail = false;
					label = "  ";
					occupiedBg = false;
					occupiedLabel = "󰮯 ";
					rounded = false;
					showWindows = true;
					shown = 5;
				};

				status = {
					showAudio = true;
					
					showBattery = true;
					showKbLayout = true;

					showLockStatus = false;

					showBluetooth = true;
					showNetwork = true;
				};

				scrollActions = {
					brightness = false;
					volume = true;

					workspaces = true;
				};
			};

			border = {
				rounding = 10;
				thickness = 10;
			};

			dashboard = {
				enabled = true;
				showOnHover = true;

				mediaUpdateInterval = 500;
				visualiserBars = 45;
			};

			launcher = {
				actionPrefix = ">";
				dragThreshold = 50;
				vimKeybinds = false;
				enableDangerousActions = false;
				maxShown = 7;
				maxWallpapers = 9;

				useFuzzy = {
					apps = false;
					actions = false;
					schemes = false;
					variants = false;
					wallpapers = false;
				};
			};

			lock = {
				maxNotifs = 5;
			};

			notifs = {
				actionOnClick = false;
				clearThreshold = 0.3;
				defaultExpireTimeout = 3000;
				expandThreshold = 20;
				expire = true;
			};

			osd = {
				hideDelay = 2000;
			};

			paths = {
				mediaGif = "root:/assets/bongocat.gif";
				sessionGif = "root:/assets/kurukuru.gif";
				wallpaperDir = "~/Pictures/Wallpapers";
			};

			services = {
				weatherLocation = "";

				useFahrenheit = false;
				useTwelveHourClock = false;

				gpuType = "AMD";

				smartScheme = true;
			};

			session = {
				dragThreshold = 30;
				vimKeybinds = false;
				commands = {
					logout = [ "hyprctl" "dispatch" "exit" ];
					shutdown = [ "systemctl" "poweroff" ];
					hibernate = [ "systemctl" "hibernate" ];
					reboot = [ "systemctl" "reboot" ];
				};
			};
		};
	};
}
