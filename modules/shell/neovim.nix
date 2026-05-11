{self, ...}: {
  flake.modules.nixos.shell = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    environment.systemPackages = [
      selfpkgs.neovim
    ];
  };
}
