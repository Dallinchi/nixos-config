{
  flake.modules.nixos.android-studio = { pkgs, ... }: {
    nixpkgs.config.android_sdk.accept_license = true;

    environment.systemPackages = [
      pkgs.android-studio
      pkgs.android-tools
    ];
  };
}

