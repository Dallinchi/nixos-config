{
  description = "AeternumOS";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-25.05";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickshell = {
      url = "git+https://git.outfoxxed.me/outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      quickshell,
      ...
    }@inputs:
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
        ];
      };
    in
    {
    nixosConfigurations = {
      hero = mkNixosConfig;
    };
  };
}

