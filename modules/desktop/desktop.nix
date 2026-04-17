{self, ...}: {
  flake.modules.nixos.desktop = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
    ];

    programs.niri.enable = true;
    programs.niri.package = selfpkgs.niri;

    environment.systemPackages = [
      # selfpkgs.terminal
      # pkgs.pcmanfm
      selfpkgs.noctalia-shell
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.jetbrains-mono
    ];
  };
}
