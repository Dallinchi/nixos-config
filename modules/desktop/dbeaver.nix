{
  flake.modules.nixos.dbeaver = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      dbeaver-bin
    ];
  };
}
