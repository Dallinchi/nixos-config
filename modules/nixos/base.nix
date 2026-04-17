{self, inputs, ...}: {
  flake.modules.nixos.nixos = {pkgs, ...}: {
    imports = [
      self.modules.nixos.shell
    ];

    nixpkgs = {
      config.allowUnfree = true;
      overlays = builtins.attrValues self.overlays;
    };

    environment = {
      shells = with pkgs; [
        fish
        bash
      ];

      systemPackages = with pkgs; [
        lact
      ];
    };

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

    console.keyMap = "us";

    system.stateVersion = "25.05"; # Do not change!

    nix.settings.allowed-users = [ "dallinchi" ];

  };
}
