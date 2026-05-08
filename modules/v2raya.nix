{
  flake.modules.nixos.v2raya = {pkgs, ...}: {
    
    systemd.services.v2raya.environment = {
      V2RAYA_V2RAY_BIN = "/run/current-system/sw/bin/xray";
    };

    services = { 
      xray = {
        enable = true;
        settingsFile = null;
        settings = {
          log = {
            loglevel = "warning";
          };
        };
      };

      v2raya.enable = true;
    };

    environment.systemPackages = with pkgs; [
      xray
      v2ray-geoip
      v2ray-domain-list-community
    ];

  };
}
