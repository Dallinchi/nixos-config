{ self, inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.noctalia-shell = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
      inherit pkgs; 
      settings =
        (builtins.fromTOML
          (builtins.readFile ./noctalia.toml));
    };
  };
}
