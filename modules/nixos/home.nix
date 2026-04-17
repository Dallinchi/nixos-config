{self, inputs, withSystem, ...}:
let
  system = "x86_64-linux";
in
{
  flake.homeConfigurations = {
    dallinchi = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = withSystem system ({ pkgs, ... }: pkgs);
      # pkgs = withSystem system ({ pkgs, ... }:
      #   import pkgs.path {
      #     inherit system;
      #     config = {
      #       allowUnfree = true;
      #     };
      #   }
      # );
      modules = [
        self.modules.home.home-manager
        self.modules.home.desktop
        self.modules.home.zen-browser
        self.modules.home.shell
        self.modules.home.alacritty
        self.modules.home.kitty
        self.modules.home.stylix

        {
          home.username = "dallinchi";
          home.homeDirectory = "/home/dallinchi";
          home.stateVersion = "25.11";
          programs.home-manager = {
            enable = true;
            # backupFileExtension = "backup";
            # useGlobalPkgs = true;
            # useUserPackages = true;

          };
        }
      ];
    };
  };
}

    # dallinchi =
    # { pkgs, ... }:
    # {
    #   imports = [
    #     # inputs.home-manager.flakeModules.home-manager
    #
    #     self.modules.home.fish
    #   ];
    #
    #   home = {
    #     username = "dallinchi";
    #     homeDirectory = "/home/dallinchi";
    #     stateVersion = "25.05";
    #   };
    #
    #   programs.home-manager.enable = true;
    #
    #   services = {
    #     home-manager.autoExpire = {
    #       enable = true;
    #       frequency = "weekly";
    #       store.cleanup = true;
    #     };
    #   };
    # };
  # };
    # nixos.nixos = { osConfig, pkgs, ... }: {
    #   imports = [
    #     inputs.home-manager.nixosModules.home-manager
    #   ];
    #
    #   home-manager = {
    #     backupFileExtension = "backup";
    #     useGlobalPkgs = true;
    #     useUserPackages = true;
    #
    #     users.dallinchi = {pkgs, ...}: {
    #
    #       imports = [
    #         self.modules.home.fish
    #       ];
    #
    #       home = {
    #         username = "dallinchi";
    #         homeDirectory = "/home/dallinchi";
    #         stateVersion = "25.05";
    #       };
    #
    #       programs.home-manager.enable = true;
    #
    #     }; 
    #   };
    # };

    # home.home-manager = {...}: {
    #
    #   # users.dallinchi = {
    #   #   imports = [
    #   #     self.modules.home.fish
    #   #     self.modules.home.taskwarrior
    #   #   ];
    #
    #     home = {
    #       username = "dallinchi";
    #       homeDirectory = "/home/dallinchi";
    #       stateVersion = "25.05";
    #     };
    #
    #     programs.home-manager.enable = true;
    #
    #   # };
    #
    # };
# }
