{ ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 80;
  };
}
