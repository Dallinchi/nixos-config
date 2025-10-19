{ inputs, username, host, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./stylix.nix
    ../../core
    ../../core/drivers
    
    inputs.home-manager.nixosModules.home-manager 
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 150;
  };

  drivers.amdgpu.enable = true;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs username host pkgs; };
    users.${username} = {
      imports = [ ../../home-manager ];
      home = {
        username = "${username}";
        homeDirectory = "/home/${username}";
        stateVersion = "25.05";
      };
    };
  };
}
