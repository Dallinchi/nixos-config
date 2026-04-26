{inputs, ...}: {
  flake.modules.nixos.prismlauncher = {pkgs, ...}: {
    environment.systemPackages = [
      pkgs.nss
      pkgs.openjdk17
      inputs.prismlauncher.packages.${pkgs.stdenv.hostPlatform.system}.prismlauncher
    ];
  };
}
