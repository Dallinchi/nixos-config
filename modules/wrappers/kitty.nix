{inputs, ...}: {
  perSystem = {pkgs, ...}: {
    packages.mytest = inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.kitty;
    };
  };
}
