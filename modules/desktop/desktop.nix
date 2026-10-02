{self, inputs, ...}: {
  flake.modules.home.desktop = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
      self.modules.home.alacritty
      self.modules.home.zen-browser
      self.modules.home.kitty
      self.modules.home.stylix
      self.modules.home.obs-studio
      self.modules.home.discord
      self.modules.home.noctalia
    ];

    systemd.user.targets.niri-session.Unit.Wants = [
      "xdg-desktop-autostart.target"
    ];
  };

  flake.modules.nixos.desktop = {pkgs, lib, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
      self.modules.nixos.pipewire
      self.modules.nixos.noctalia
    ];
    
    environment.systemPackages = [
      selfpkgs.niri
      selfpkgs.niri-session

      pkgs.alacritty
      pkgs.kitty
      pkgs.libreoffice
      pkgs.dbeaver-bin
    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "gnome";
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

      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    services = {

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${lib.getExe (selfpkgs.niri-session)}";
          };
        };
      };

    };

  };
}
