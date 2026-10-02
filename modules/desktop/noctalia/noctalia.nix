{inputs, ...}: {
  flake.modules.nixos.noctalia = {
    imports = [
      inputs.noctalia.nixosModules.default
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true; 
    };

  };

  flake.modules.home.noctalia = {lib, ...}:{
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia = {
      enable = true;
      systemd.enable = true; 

      settings = lib.mkForce ./noctalia.toml;
    };
  };
}
