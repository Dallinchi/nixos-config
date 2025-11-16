{
  description = "AeternumOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    
    # System colors 
    stylix.url = "github:danth/stylix/release-25.05";
 
    # System secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # User configurations
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # qt widgets/shells
    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Caelestia shell for niri
    niri-caelestia-shell = {
      url = "github:jutraim/niri-caelestia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    # Caelestia shell for hyprland
    caelestia-shell = {
      url = "github:caelestia-dots/shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    
    hyprland.url = "github:hyprwm/Hyprland";
    
    # Hyprland split-monitor-workspaces plugin
    split-monitor-workspaces = {
      url = "github:Duckonaut/split-monitor-workspaces";
      inputs.hyprland.follows = "hyprland";
    };

    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Widgets
    way-edges = {
      url = "github:way-edges/way-edges";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Nvchad neovim for nixos
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
    };

    # Deduplicate nixosConfigurations while preserving the top-level 'profile'
    mkNixosConfig = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = {
        inherit inputs;
        inherit username;
        inherit host;
      };
      modules = [
        ./hosts/${host}
        ./overlays
      ];
    };
      
  in {
    nixosConfigurations = {
      hero = mkNixosConfig;
    };
  };
}

