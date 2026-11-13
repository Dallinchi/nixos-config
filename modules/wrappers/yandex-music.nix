
{ self, inputs, ... }:

{
  perSystem = { system, ... }:
    let
      pkgs = import inputs.nixpkgs {
        inherit system;

        config.allowUnfreePredicate = pkg:
          builtins.elem (inputs.nixpkgs.lib.getName pkg) [
            "yandex-music"
          ];
      };

      version = "5.127.0";

      yandexMusicPayload = pkgs.stdenvNoCC.mkDerivation {
        pname = "yandex-music-payload";
        inherit version;

        src = pkgs.fetchurl {
          url = "https://desktop.app.music.yandex.net/stable/Yandex_Music_amd64_${version}.deb";
          hash = "sha256-Xn/B6hjE+ijGSf453yw6av+tTRvwBQFDgVaazCOOVXs=";
        };

        nativeBuildInputs = [
          pkgs.dpkg
        ];

        dontUnpack = true;
        dontBuild = true;
        dontFixup = true;

        installPhase = ''
          runHook preInstall

          root="$TMPDIR/deb-root"

          mkdir -p \
            "$root" \
            "$out/opt/yandex-music" \
            "$out/share/icons" \
            "$out/share/pixmaps"

          dpkg-deb --extract "$src" "$root"

          appBin="$(find "$root/opt" \
            -name yandexmusic \
            -print -quit)"

          if [ -z "$appBin" ] || [ ! -x "$appBin" ]; then
            echo "ERROR: yandexmusic executable not found!" >&2
            echo "Contents of /opt:" >&2
            find "$root/opt" -maxdepth 4 -print >&2
            exit 1
          fi

          appDir="$(dirname "$appBin")"

          echo "Found Yandex Music: $appBin"

          cp -a "$appDir"/. "$out/opt/yandex-music/"

          if [ -d "$root/usr/share/icons" ]; then
            cp -a "$root/usr/share/icons/." \
              "$out/share/icons/"
          fi

          if [ -d "$root/usr/share/pixmaps" ]; then
            cp -a "$root/usr/share/pixmaps/." \
              "$out/share/pixmaps/"
          fi

          test -x "$out/opt/yandex-music/yandexmusic"

          runHook postInstall
        '';
      };

      yandexMusicDesktop = pkgs.makeDesktopItem {
        name = "yandex-music";
        desktopName = "Яндекс Музыка";
        genericName = "Music Player";

        exec = "yandex-music %U";
        icon = "yandexmusic";

        terminal = false;
        startupNotify = true;

        categories = [
          "AudioVideo"
          "Audio"
          "Player"
        ];
      };

      yandexMusic = pkgs.buildFHSEnv {
        pname = "yandex-music";
        inherit version;

        executableName = "yandex-music";

        targetPkgs = p: with p; [
          # Audio
          alsa-lib
          libpulseaudio

          # GTK
          gtk3
          glib
          cairo
          pango
          atk
          at-spi2-atk
          at-spi2-core
          gdk-pixbuf
          harfbuzz

          # Desktop integration
          dbus
          cups
          libnotify
          libsecret
          libappindicator
          expat
          udev
          xdg-utils
          shared-mime-info

          # Fonts
          fontconfig
          freetype

          # Security and system
          nss
          nspr
          stdenv.cc.cc
          zlib
          libuuid

          # Graphics
          libGL
          libdrm
          libgbm
          mesa
          vulkan-loader

          # X11 / Wayland
          libx11
          libxcomposite
          libxcursor
          libxdamage
          libxext
          libxfixes
          libxi
          libxrandr
          libxrender
          libxtst
          libxcb
          libxshmfence
          libxkbcommon
          libxkbfile
          libxscrnsaver
        ];

        runScript = pkgs.writeShellScript "yandex-music-run" ''
          exec "${yandexMusicPayload}/opt/yandex-music/yandexmusic" \
            --gtk-version=3 \
            --disable-setuid-sandbox \
            "$@"
        '';

        extraInstallCommands = ''
          mkdir -p "$out/share/applications"

          install -Dm644 \
            "${yandexMusicDesktop}/share/applications/yandex-music.desktop" \
            "$out/share/applications/yandex-music.desktop"

          mkdir -p "$out/share/icons"

          cp -a "${yandexMusicPayload}/share/icons/." \
            "$out/share/icons/"

          mkdir -p "$out/share/pixmaps"

          cp -a "${yandexMusicPayload}/share/pixmaps/." \
            "$out/share/pixmaps/"
        '';

        meta = with pkgs.lib; {
          description = "Official Yandex Music desktop application";
          homepage = "https://music.yandex.ru/";
          license = licenses.unfree;
          platforms = [ "x86_64-linux" ];
          mainProgram = "yandex-music";
        };
      };

    in
    {
      # Make configured pkgs available to other perSystem modules.
      _module.args.pkgs = pkgs;

      packages.yandex-music = yandexMusic;
      packages.default = yandexMusic;
    };

  flake.nixosModules.yandex-music = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.yandex-music
    ];
  };
}

