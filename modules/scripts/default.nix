{
  host,
  ...
}:
{
  imports = [
    ./network-namespaces.nix
    ./utils.nix
    ./src
  ];
}
