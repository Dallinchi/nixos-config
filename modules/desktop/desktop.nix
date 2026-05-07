{self, ...}: {
  flake.modules.home.desktop = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
      self.modules.home.swayosd
      self.modules.home.rofi

      self.modules.home.alacritty
      self.modules.home.zen-browser
      self.modules.home.kitty
      self.modules.home.stylix
      self.modules.home.obs-studio
      self.modules.home.discord
    ];

    systemd.user.targets.niri-session.Unit.Wants = [
      "xdg-desktop-autostart.target"
    ];

    home.packages = [
      selfpkgs.noctalia-shell
      selfpkgs.niri
    ];
  };
}
