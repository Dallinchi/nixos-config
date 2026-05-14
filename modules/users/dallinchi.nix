{self, inputs, withSystem, ...}:
let
  system = "x86_64-linux";
in
{
  flake.modules.nixos.dallinchi = {pkgs, config, ...}: {
    
    imports = [ inputs.sops-nix.nixosModules.sops ];

    sops.secrets."dallinchi-password" = {
      sopsFile = ../../secrets/users.yaml;
      key = "users/dallinchi/hashed";
      neededForUsers = true;
      mode = "0400";
    };
    
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
      hashedPasswordFile = config.sops.secrets."dallinchi-password".path;
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
