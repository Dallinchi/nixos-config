{ inputs, username, host, pkgs, ... }: {

  imports = [
    inputs.home-manager.nixosModules.home-manager 
  ];

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
