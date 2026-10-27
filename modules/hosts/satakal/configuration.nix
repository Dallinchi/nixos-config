{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.satakal = inputs.nixpkgs-stable.lib.nixosSystem {
    system = "x86_64-linux";
    modules = [
      self.hosts.satakal
    ];
  };
  
  flake.packages.x86_64-linux.satakal = self.nixosConfigurations.satakal.config.system.build.isoImage;
  
  flake.hosts.satakal = {pkgs, lib, modulesPath, ...}: {
    # import any other modules from here
    imports = [
      (modulesPath + "/installer/cd-dvd/installation-cd-minimal.nix")
    
      self.modules.nixos.scripts
      self.modules.nixos.nixos
      self.modules.nixos.desktop

      self.modules.nixos.v2raya

      self.modules.nixos.dallinchi
    ];
 
    boot.kernelPackages = lib.mkForce pkgs.linuxPackages;
    
    networking = {
      hostName = "satakal";
      networkmanager.enable = true;
      dhcpcd.wait = "background";
      dhcpcd.extraConfig = "noarp";
      firewall = {
        enable = true;
        allowedTCPPorts = [ ];
        allowedUDPPorts = [ ];
      };
    };

    # Services to start
    systemd.services.NetworkManager-wait-online.enable = false;
    systemd.services.audit.enable = false;
    systemd.services.nix-daemon.serviceConfig = {
      MemoryHigh = "4G";
      MemoryMax = "5G";
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
        
    security.rtkit.enable = true;

    services = {

      xserver.enable = true;
      fstrim.enable = true; # SSD Optimizer
      upower.enable = true;
      gvfs.enable = true; # For Mounting USB & More
      udisks2.enable = true;
      gnome.gnome-keyring.enable = true;
      
      tlp = {
        enable = false;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "schedutil";
        };
      };
    };
  };
}
