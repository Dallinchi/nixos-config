{
  pkgs,
  username,
  ... }:
{
  # Services to start
  systemd.services.NetworkManager-wait-online.enable = false;
  systemd.services.audit.enable = false;
  systemd.services.nix-daemon.serviceConfig = {
    MemoryHigh = "3G";
    MemoryMax = "4G";
  };

  services = {
    libinput.enable = true; # Input Handling
    fstrim.enable = true; # SSD Optimizer
    #audit.enable = false; # SHUTUP
    upower.enable = true;
    gvfs.enable = true; # For Mounting USB & More
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
    blueman.enable = true; # Bluetooth Support
    tumbler.enable = true; # Image/video preview
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
          command = "${pkgs.greetd.tuigreet}/bin/tuigreet --time --cmd Hyprland"; # start Hyprland with a TUI login manager
        };
      };
    };
  };
}
