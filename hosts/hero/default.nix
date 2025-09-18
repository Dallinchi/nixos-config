{ inputs, username, host, pkgs, ... }: {
  imports = [
    ./hardware.nix
    ./host-packages.nix
    ./stylix.nix
    ../../core
    ../../core/drivers
    
    inputs.home-manager.nixosModules.home-manager 
#    ../../home-manager
  ];

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 80;
  };

  drivers.amdgpu.enable = true;
  drivers.nvidia.enable = false;
  drivers.nvidia-prime.enable = false;
  drivers.intel.enable = false;
  vm.guest-services.enable = false;

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = false;
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
