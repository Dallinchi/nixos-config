{ inputs, username, host, pkgs, system, options, ... }:
let
  inherit (import ./variables.nix) hostId;
  inherit (import ./variables.nix) consoleKeyMap;
  inherit (import ./variables.nix) gitUsername;
in
{
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./stylix.nix
    ../../modules
    
    inputs.sops-nix.nixosModules.sops
    inputs.home-manager.nixosModules.home-manager 
  ];

  nix = {
    settings = {
      download-buffer-size = 200000000;
      auto-optimise-store = true;
      experimental-features = [
        "nix-command"
        "flakes"
      ];
#      substituters = [ "https://hyprland.cachix.org" ];
#      trusted-public-keys = [ "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc=" ];
    };
  };
  
  time.timeZone = "Europe/Moscow";
  time.hardwareClockInLocalTime = false;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
  
  environment.variables = {
#    NIXOS_OZONE_WL = "1";
#    AETERNUMOS_VERSION = "0.2";
#    AETERNUMOS = "true";
  };
  
  console.keyMap = "${consoleKeyMap}";
  system.stateVersion = "25.05"; # Do not change!
  
  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 150;
  };

  users.mutableUsers = true;
  users.users.${username} = {
    isNormalUser = true;
    description = "${gitUsername}";
    extraGroups = [
     # "adbusers"
     # "docker" #access to docker as non-root
     # "libvirtd" #Virt manager/QEMU access
     # "lp"
      "networkmanager"
     # "scanner"
      "wheel" #subdo access
     # "vboxusers" #Virtual Box
    ];
    shell = pkgs.fish;
    ignoreShellProgramCheck = true;
  };
  nix.settings.allowed-users = [ "${username}" ];

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username host pkgs; };
    users.${username} = {
      imports = [ ../../home-manager ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };
    };
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
    hostName = "${host}";
    hostId = hostId;
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

  services = {
    
    xserver.videoDrivers = [ "amdgpu" ];
    
    # libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    #audit.enable = false; # SHUTUP
    upower.enable = true;
    gvfs.enable = true; # For Mounting USB & More
    udisks2.enable = true;
    preload.enable = true; # Caching
    openssh = {
      enable = false; # Enable SSH
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
      vt = 3;
      settings = {
        default_session = {
          user = username;
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd niri"; # start Hyprland with a TUI login manager
        };
      };
    };
  };
}
