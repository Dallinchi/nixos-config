{self, inputs, ...}: {
  flake.modules.home.desktop = {pkgs, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
      self.modules.home.alacritty
      self.modules.home.zen-browser
      self.modules.home.kitty
      self.modules.home.stylix
      self.modules.home.obs-studio
      self.modules.home.discord
      self.modules.home.noctalia
    ];

    systemd.user.targets.niri-session.Unit.Wants = [
      "xdg-desktop-autostart.target"
    ];

    xdg = {
      enable = true;
      mime.enable = true;
    };

  };

  flake.modules.nixos.desktop = {pkgs, lib, ...}: let
    selfpkgs = self.packages."${pkgs.stdenv.hostPlatform.system}";
  in {
    imports = [
      self.modules.nixos.pipewire
      self.modules.nixos.noctalia
    ];
    
    environment.systemPackages = with pkgs; [
      selfpkgs.niri
      selfpkgs.niri-session

      alacritty
      kitty
      libreoffice
      pulseaudio # For pactl
      filezilla # FTP Client
      btop # System monitor
      brightnessctl # For Screen Brightness Control
      ffmpeg # Terminal Video / Audio Editing
      mpv # Incredible Video Player
      pavucontrol # For Editing Audio Levels & Devices
      playerctl # Allows Changing Media Volume Through Scripts
      usbutils # Good Tools For USB Devices
      v4l-utils # Used For Things Like OBS Virtual Camera
      tofi # Launch menu
      swaybg # Wallpaper
      fastfetch # System info
      wl-clipboard # Clipboard
      cliphist
      telegram-desktop # Chat
      nsxiv # Image viewer
      seafile-client # Cloud
      libnotify # Notify utils
      obsidian # Notes
      hyprshot # Screenshots
      yandex-music
      nautilus
      wineWow64Packages.stable # support both 32-bit and 64-bit applications
      winetricks # winetricks (all versions)
      vscode # Text editor
      xwayland-satellite # Xwayland for niri 
      chatterino7 # Twitch chat
      papers # Books reader
      transmission_4-gtk
      steam-run
      (pkgs.lutris.override {
         extraPkgs = p: with p; [
           vdpauinfo
           libvdpau
           libtheora
           speex
           libgudev
           gvfs

           # Force 32-bit compatibility layers for GStreamer
           pkgsi686Linux.libtheora
           pkgsi686Linux.libvdpau
         ];
       })

      gparted
      alsa-utils

    ];

    xdg.portal = {
      enable = true;
      extraPortals = [ pkgs.xdg-desktop-portal-gnome ];
      config.common.default = "gnome";
    };

    hardware = {
      graphics = {
        enable = true;

        enable32Bit = true;
        extraPackages = with pkgs; [
          mesa
          vulkan-loader
          vulkan-validation-layers
        ];
      };

      bluetooth.enable = true;
      bluetooth.powerOnBoot = true;
    };

    services = {

      greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd ${lib.getExe (selfpkgs.niri-session)}";
          };
        };
      };

    };

  };
}
