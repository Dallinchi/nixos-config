{ inputs, pkgs, ... }:
{
	imports = [
		inputs.caelestia-shell.homeManagerModules.default
	];

  home.packages = with pkgs; [
    gpu-screen-recorder
  ];

	programs.caelestia = {
		enable = true;
	
		systemd = {
			enable = false;
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
          base = 0.7;
          layers = 1;
        };

        font = {
          family = {
            clock = "Rubik";
            material = "Material Symbols Rounded";
            mono = "CaskaydiaCove NF";
            sans = "Rubik";
          };
          size = {
            scale = 0.9;
          };
        };

        padding = {
          scale = 0.8;
        };

        rounding = {
          scale = 1;
          small = 10;
          normal = 10;
          large = 10;
          full = 8;
        };

        spacing = {
          scale = 1;
        };

        anim = {
          durations = {
            scale = 0.7;
          };
        };
      };

			general = {
				apps = {
					terminal = [ "alacritty" ];
					audio = [ "pavucontrol" ];
					explorer = [ "thunar" ];
				};

        idle = {
          lockBeforeSleep = true;
          inhibitWhenAudio = true;
          timeouts = [
            {
              timeout = 180;
              idleAction = "lock";
            }
            {
              timeout = 300;
              idleAction = "dpms off";
              returnAction = "dpms on";
            }
            {
              timeout = 1200;
              idleAction = ["systemctl" "suspend-then-hibernate"];
            }
          ];
        };
			};

			background = {
				enabled = true;

				desktopClock = {
					enabled = true;
				};
			};

			bar = {
				persistent = false;
				showOnHover = false;
        
        sizes = {
          innerWidth = 29;
          windowPreviewSize = 300;
          trayMenuWidth = 300;
          batteryWidth = 250;
          networkWidth = 320;
        };

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
					activeTrail = true;
					label = "  ";
					occupiedBg = true;
					occupiedLabel = "󰮯 ";
          perMonitorWorkspaces = true; # Разделение виджета для монитора
					showWindows = true;
					shown = 8;
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
				thickness = 5;
			};

			dashboard = {
				enabled = false;
				showOnHover = true;

				mediaUpdateInterval = 500;
				visualiserBars = 45;
			};

			launcher = {
				enabled = false;
				actionPrefix = "/";
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
				actionOnClick = true;
				clearThreshold = 0.3;
				defaultExpireTimeout = 3000;
				expandThreshold = 20;
				expire = true;
			};

			osd = {
				hideDelay = 500;
        enableBrightness = false;
        enableMicrophone = false;
        sizes = {
          sliderHeight = 300;
          sliderWidth = 25;
        };
			};

			paths = {
				mediaGif = "root:/assets/bongocat.gif";
				sessionGif = "root:/assets/kurukuru.gif";
				wallpaperDir = "~/Pictures/Wallpapers";
			};

			services = {
				weatherLocation = "Kazan";

				useFahrenheit = false;
				useTwelveHourClock = false;

				gpuType = "";

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

      utilities = {
        enabled = true;
        maxToasts = 4;
        toasts = {
          audioInputChanged = true;
          audioOutputChanged = true;
          capsLockChanged = false;
          chargingChanged = false;
          configLoaded = false;
          dndChanged = false;
          gameModeChanged = false;
          numLockChanged = false;
        };
      };
		};
	};
}
