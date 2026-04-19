{self, inputs, withSystem, ...}:
let
  system = "x86_64-linux";
in
{
  flake.modules.nixos.nixos = {pkgs, ...}: {

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
      pkgs = withSystem system ({ pkgs, ... }: pkgs);

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
        }
      ];
    };
  };

}
