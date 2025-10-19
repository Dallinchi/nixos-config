{
  pkgs,
  inputs,
  ...
}: {
  nixpkgs.overlays = [
    (final: prev: {

      yandex-music = prev.yandex-music.overrideAttrs (oldAttrs: rec {
        ymExe = prev.fetchurl {
          url = "https://music-desktop-application.s3.yandex.net/stable/Yandex_Music_x64_5.57.0.exe";
          sha256 = "148afbede1f492c2922c32416f24d277f424c1dd5415cfd5149dc61276ce0fdd";
        };
      });

      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    })
  ];
}
