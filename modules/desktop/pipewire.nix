{
  flake.modules.nixos.pipewire = {
    services.pipewire = {
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
            "default.clock.min-quantum" = 1024;
            "default.clock.quantum" = 1024;
            "default.clock.max-quantum" = 2048;
          };
        };

      };
    };
  };
}
