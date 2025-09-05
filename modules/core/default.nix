{
  inputs,
  host,
  ...
}:
{
  imports = [
    ./boot.nix
    ./hardware.nix
    ./network.nix
    ./packages.nix
    ./services.nix
    ./system.nix
    ./user.nix
  ];
}
