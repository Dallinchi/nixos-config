{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.11";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    wrappers = {
      url = "github:Lassulus/wrappers";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # System colors 
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # System secrets
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Impove firefox
    betterfox = {
      url = "github:yokoffing/Betterfox";
      flake = false;
    };
    
    # firefox-based browser
    zen-browser = {
      # url = "github:0xc000022070/zen-browser-flake?ref=1.20t-1772605766";
      url = "github:0xc000022070/zen-browser-flake?rev=869e4ed0c5b6962d0e344a89542257f383440b9e";
      # url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    
    # Nvchad neovim for nixos
    nix4nvchad = {
      url = "github:nix-community/nix4nvchad";
      inputs.nixpkgs.follows = "nixpkgs";
    };    
    
    # Window manager
    niri = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Niri fullscreen manager
    nfsm-flake = {
      url = "github:gvolpe/nfsm";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    
    # Minecraft server
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
    };

    prismlauncher = {
      url = "github:PrismLauncher/PrismLauncher?ref=9.3";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
