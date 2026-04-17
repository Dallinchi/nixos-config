{ lib, inputs, moduleLocation, ... }:
let
  inherit (lib)
    mapAttrs
    mkOption
    types
    ;
in
{ 
  imports = [

    inputs.home-manager.flakeModules.home-manager
  ];
  options.flake = {

    modules = mkOption {
      type = types.submodule {
        options = {
          nixos = mkOption {
            type = types.lazyAttrsOf types.deferredModule;
            default = {};
            apply = mapAttrs (k: v: {
              _class = "nixos";
              _file = "${toString moduleLocation}#nixosModules.${k}";
              imports = [ v ];
            });
          };

          home = mkOption {
            type = types.lazyAttrsOf types.deferredModule;
            default = {};
            apply = mapAttrs (k: v: {
              _class = "homeManager";
              _file = "${toString moduleLocation}#homeModules.${k}";
              imports = [ v ];
            });
          };
        };
      };
      default = {};
    };

    hosts = mkOption {
      type = types.lazyAttrsOf types.deferredModule;
      default = { };
      apply = mapAttrs (k: v: {
        _class = "nixos";
        _file = "${toString moduleLocation}#nixosModules.${k}";
        imports = [ v ];
      });
      description = ''
        NixOS modules.

        You may use this for reusable pieces of configuration, service modules, etc.
      '';
    };
        
  };

  config = {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
}
