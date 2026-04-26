{self, inputs, ...}: {
  flake.modules.nixos.minecraft-servers = {pkgs, ...}: {
    imports = [ inputs.nix-minecraft.nixosModules.minecraft-servers ];
  
    nixpkgs.overlays = [ inputs.nix-minecraft.overlay ];
    
    services.minecraft-servers = {
      enable = true;
      eula = true;

      openFirewall = true;

      servers = {
        komam = {
          enable = true;
          package = pkgs.neoforgeServers.neoforge-1_21_1;
          autoStart = false;
          # symlinks = {
          #   "mods" = ./mods;
          # };
         
          jvmOpts = "-Xms6144M -Xmx8192M";

          serverProperties = {
            online-mode = false;
            server-port = 43000;
          };
        };
      };
    };
  };
}
