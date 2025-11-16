{ pkgs, inputs, config, username, ...}:
{
  imports = [
    inputs.sops-nix.nixosModules.sops
  ];

  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/home/${username}/.config/sops/age/keys.txt";

  sops.secrets."openconnect/tlinmo/username" = {
    owner = username;
  };
  sops.secrets."openconnect/tlinmo/server" = {
    owner = username;
  };
  sops.secrets."openconnect/tlinmo/password" = {
    owner = username;
  };

}
