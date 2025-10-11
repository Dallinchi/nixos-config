{
  description = "AeternumOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    stylix.url = "github:danth/stylix/release-25.05";
    
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hyprland.url = "github:hyprwm/Hyprland";
    
    # Hyprland split-monitor-workspaces plugin
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };    

    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };

  };

  outputs = { self, nixpkgs, ... }@inputs:
  let
    system = "x86_64-linux";
    host = "hero";
    username = "dallinchi";

    pkgs = import nixpkgs { 
      inherit system;
      config.allowUnfree = true;

      overlays = [
        (final: prev: {

          yandex-music = prev.yandex-music.overrideAttrs (oldAttrs: rec {
            ymExe = prev.fetchurl {
              url = "https://music-desktop-application.s3.yandex.net/stable/Yandex_Music_x64_5.57.0.exe";
              sha256 = "148afbede1f492c2922c32416f24d277f424c1dd5415cfd5149dc61276ce0fdd";
            };
          });

          yandex-music-custom = final.yandex-music;
        
        })
      ];
    };

    # Deduplicate nixosConfigurations while preserving the top-level 'profile'
    mkNixosConfig = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username;
        inherit host;
        inherit pkgs; 
      };
      modules = [
        ./hosts/${host}
      ];
    };
      
  in {
    nixosConfigurations = {
      hero = mkNixosConfig;
    };
  };
}

