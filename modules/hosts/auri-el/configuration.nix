{ 
  inputs,
  self,
  options,
  ... 
}: {
  flake.nixosConfigurations.auri-el = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.hosts.auri-el
    ];
  };

  flake.hosts.auri-el = {pkgs, lib, options, ...}: {
    # import any other modules from here
    imports = [
      self.modules.nixos.nixos 
      self.modules.nixos.scripts
      # self.modules.nixos.desktop 
      self.modules.nixos.stylix
      self.modules.nixos.gaming

      self.modules.nixos.v2raya

      self.modules.nixos.dallinchi

    ];

    environment.variables = {
      VPN_NAMESPACE_INTERFACE = "wlp2s0"; # for start-vpn-namespace script
    };
    
    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 150;
    };

    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [ "video=eDP-1:1920x1080@60" "video=HDMI-A-1:1920x1080@60" ];
      # kernelModules = [ "v4l2loopback" ];
      # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernel.sysctl = { 
        "vm.max_map_count" = 65530;
        "kernel.pid_max" = 32768;
      };
      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.timeout = 0;

      # Appimage Support
      #binfmt.registrations.appimage = {
      #  wrapInterpreterInShell = false;
      #  interpreter = "${pkgs.appimage-run}/bin/appimage-run";
      #  recognitionType = "magic";
      #  offset = 0;
      #  mask = ''\xff\xff\xff\xff\x00\x00\x00\x00\xff\xff\xff'';
      #  magicOrExtension = ''\x7fELF....AI\x02'';
      #};
     # plymouth.enable = true;
    };

    hardware = {
    #   sane = {
    #    enable = true;
    #    extraBackends = [ pkgs.sane-airscan ];
    #    disabledDefaultBackends = [ "escl" ];
    #  };
     # logitech.wireless.enable = false;
     # logitech.wireless.enableGraphical = false;
      graphics.enable = true; # OpenGL
     # enableRedistributableFirmware = true;
     # keyboard.qmk.enable = true;
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    networking = {
      hostName = "auri-el";
      networkmanager.enable = true;
      dhcpcd.wait = "background";
      dhcpcd.extraConfig = "noarp";
      timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      firewall = {
        enable = true;
        allowedTCPPorts = [
          #22
          #80
          #443
          #8080
        ];
        allowedUDPPorts = [
          #59010
          #59011
        ];
      };
    };

    # Services to start
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.audit.enable = false;
    systemd.services.nix-daemon.serviceConfig = {
      MemoryHigh = "3G";
      MemoryMax = "4G";
    };
    
    security.rtkit.enable = true;
    
    services = {
      
      xserver.videoDrivers = [ "amdgpu" ];
      
      # libinput.enable = true; # Input Handling
      fstrim.enable = true; # SSD Optimizer
      #audit.enable = false; # SHUTUP
      upower.enable = true;
      gvfs.enable = true; # For Mounting USB & More
      udisks2.enable = true;
      openssh = {
        enable = true; # Enable SSH
        settings = {
          PermitRootLogin = "no"; # Prevent root from SSH login
          PasswordAuthentication = true; #Users can SSH using kb and password
          KbdInteractiveAuthentication = true;
        };
        ports = [ 22 ];
      };
      journald.extraConfig = "SystemMaxUser=50m"; # Max weight logs
      # blueman.enable = true; # Bluetooth Support
      # tumbler.enable = true; # Image/video preview
      gnome.gnome-keyring.enable = true;

      smartd = {
        enable = true;
        autodetect = true;
      };
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
        extraConfig.pipewire."92-low-latency" = {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 256;
            "default.clock.min-quantum" = 256;
            "default.clock.max-quantum" = 256;
          };
        };
        extraConfig.pipewire-pulse."92-low-latency" = {
          context.modules = [
            {
              name = "libpipewire-module-protocol-pulse";
              args = {
                pulse.min.req = "256/48000";
                pulse.default.req = "256/48000";
                pulse.max.req = "256/48000";
                pulse.min.quantum = "256/48000";
                pulse.max.quantum = "256/48000";
              };
            }
          ];
        };
      };
      system76-scheduler.settings.cfsProfiles.enable = true;   # Better scheduling for CPU cycles - thanks System76!!!
      thermald.enable = true;                                  # Enable thermald, the temperature management daemon. (only necessary if on Intel CPUs)
      power-profiles-daemon.enable = false;
      tlp = {
        enable = true;
        settings = { 
          CPU_BOOST_ON_AC = 0;
          CPU_BOOST_ON_BAT = 0;
          CPU_HWP_DYN_BOOST_ON_AC = 0;
          CPU_HWP_DYN_BOOST_ON_BAT = 0;
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_ENERGY_PERF_POLICY_ON_BAT = "balance_power";
          START_CHARGE_THRESH_BAT0 = 75;
          STOP_CHARGE_THRESH_BAT0 = 81;
        };
      };

      greetd = {
        enable = true;
        settings = {
          default_session = {
            user = "dallinchi";
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd niri"; # start Hyprland with a TUI login manager
          };
        };
      };
    };
  };
}
