{self, inputs, withSystem, ...}:
let
  system = "x86_64-linux";
in
{
  flake.modules.nixos.dallinchi = {pkgs, ...}: {
    
    users.users.dallinchi = {
      isNormalUser = true;
      description = "Dallinchi";
      shell = pkgs.fish;
      ignoreShellProgramCheck = true;
      extraGroups = [
        "wheel"
        "input"
        "networkmanager"
        "podman"
      ];
      
    };

  };

  flake.homeConfigurations = {
    dallinchi = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ system, ... }:
        import inputs.nixpkgs {
          inherit system;

          config.allowUnfree = true;

          overlays = [
            self.overlays.stable-packages
          ];
        }
      );
      modules = [
        self.modules.home.home-manager
        self.modules.home.desktop
        self.modules.home.shell

        {
          home.username = "dallinchi";
          home.homeDirectory = "/home/dallinchi";
        }
      ];
    };
  };

}
