{
  inputs,
  self,
  options,
  ...
}: {
  flake.nixosConfigurations.stendarr = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.hosts.stendarr
    ];
  };

  flake.hosts.stendarr = {pkgs, lib, options, ...}: {
    # import any other modules from here
    imports = [
      self.modules.nixos.nixos
      self.modules.nixos.scripts
      # self.modules.nixos.desktop 
      self.modules.nixos.stylix 

      self.modules.nixos.minecraft-servers
      self.modules.nixos.prismlauncher
      self.modules.nixos.gaming
      self.modules.nixos.v2raya

      self.modules.nixos.dallinchi
    ];

    fileSystems = {
      "/mnt/storage0" = {
        device = "/dev/disk/by-uuid/87d935d9-cfb4-410c-8f76-f95d4a0031d9";
        fsType = "btrfs";
        options = [ "nofail" ];
      };

      "/" = {
        device = "/dev/disk/by-uuid/0aeb1b66-486b-46f9-8768-254f86738623";
        fsType = "btrfs";
        options = [ "compress=zstd" "noatime" ];
      };
    };

    environment.variables = {
      VPN_NAMESPACE_INTERFACE = "enp4s0"; # for start-vpn-namespace script
    };

    zramSwap = {
      enable = true;
      algorithm = "zstd";
      memoryPercent = 50;
    };

    xdg.portal = {
      enable = true;
      config.common.default = "*";
    };

    virtualisation = {
      containers.enable = true;

      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };

    };

    virtualisation.vmVariant = {
      virtualisation.sharedDirectories = {
        shared = {
          source = lib.mkForce "/home/dallinchi/Desktop/nixconf-mk4";
        };
      };
      virtualisation.diskSize = 20480; # в MB (20 GB)
      virtualisation.memorySize = 8096;
    };

    boot = {
      kernelPackages = pkgs.linuxPackages_zen;
      kernelParams = [
        "sched_migration_cost_ns=5000000"
          "cgroup_no_v1=all"
          "mem_sleep_default=deep"
          "video=DVI-D-1:1920x1080@60" "video=HDMI-A-1:1920x1080@60"
      ];
      # kernelModules = [ "v4l2loopback" ];
      # extraModulePackages = [ config.boot.kernelPackages.v4l2loopback ];
      kernel.sysctl = { 
        "vm.max_map_count" = 262144;
        "kernel.pid_max" = 32768;
        "vm.swappiness" = 10;
        "vm.vfs_cache_pressure" = 50;
        "kernel.sched_autogroup_enabled" = 1;
      };

      loader.systemd-boot.enable = true;
      loader.efi.canTouchEfiVariables = true;
      loader.timeout = 0;

    };

    hardware = {

      graphics = {
        enable = true;

        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
            vulkan-loader
            vulkan-validation-layers
        ];
      };
      # OpenGL
      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    networking = {
      hostName = "stendarr";
      networkmanager.enable = true;
      dhcpcd.wait = "background";
      dhcpcd.extraConfig = "noarp";
      # timeServers = options.networking.timeServers.default ++ [ "pool.ntp.org" ];
      firewall = {
        enable = true;
        allowedTCPPorts = [
          #22
          #80
          #443
          8000
          8080 # Seafile
          
          53149 # Minecraft

          21 # FTP
        ];
        allowedUDPPorts = [
          # 59010
          # 59011
          53149 # Minecraft
        ];

        allowedTCPPortRanges = [
        # FTP passive
        { from = 30000; to = 31000; }
        ];
      };
    };

    # Services to start
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.audit.enable = false;
    systemd.services.nix-daemon.serviceConfig = {
      MemoryHigh = "6G";
      MemoryMax = "7G";
    };
    systemd.services.lact = {
      description = "AMDGPU Control Daemon";
      after = ["multi-user.target"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.lact}/bin/lact daemon";
      };
      enable = true;
    };

    services = {

      xserver = {
        enable = true;
        videoDrivers = [ "amdgpu" ];
        xkb.options = "model:pc86";
      };

      # FTP server
      vsftpd = {
        enable = true;
        writeEnable = true;
        localUsers = true;
        anonymousUser = false;
        extraConfig = ''
          pasv_enable=YES
          pasv_min_port=30000
          pasv_max_port=31000
          '';
      };

      # libinput.enable = true; # Input Handling
      fstrim.enable = true; # SSD Optimizer
      #audit.enable = false; # SHUTUP
      flatpak.enable = true;
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
        wireplumber.enable = true;

        extraConfig.pipewire = {
          "92-sample-rate" = {
            "context.properties" = {
              "default.clock.rate" = 48000;
              "default.clock.allowed-rates" = [ 48000 ];
            };
          };
          "92-buffer" = {
            "context.properties" = {
              "default.clock.quantum" = 1024;
              "default.clock.min-quantum" = 1024;
              "default.clock.max-quantum" = 2048;
            };
          };
        };
      };
      
      power-profiles-daemon.enable = true;
      
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
