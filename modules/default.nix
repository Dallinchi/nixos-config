{
  inputs,
  host,
  ...
}:
{
  imports = [
    # ./boot.nix
    # ./hardware.nix
    # ./network.nix
    ./packages.nix
    # ./services.nix
    ./secrets.nix
    # ./system.nix
    # ./user.nix
    ./scripts
  ];
}
