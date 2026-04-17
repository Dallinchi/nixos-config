{ inputs, system, config, ... }: {

  perSystem = { system, ... }: {
    _module.args.pkgs = import inputs.nixpkgs {
      inherit system;

      config.allowUnfree = true;
      
      overlays = [
        # inputs.foo.overlays.default
        inputs.niri.overlays.niri
        (final: prev: {

          stable = import inputs.nixpkgs-stable {
            inherit system;
            config.allowUnfree = true;
          };

          # ... things you need to patch ...
        })
      ];
      config = { };
    };
  };
}
