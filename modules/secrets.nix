{inputs, ...}: {
  flake.modules.nixos.nixos = { pkgs, config, ...}:
  {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops.defaultSopsFile = ../secrets/secrets.yaml;
    sops.defaultSopsFormat = "yaml";
    sops.age.keyFile = "/home/dallinchi/.config/sops/age/keys.txt";

    sops.secrets."openconnect/tlinmo/username" = {
      owner = "dallinchi";
    };
    sops.secrets."openconnect/tlinmo/server" = {
      owner = "dallinchi";
    };
    sops.secrets."openconnect/tlinmo/password" = {
      owner = "dallinchi";
    };

  };
}
