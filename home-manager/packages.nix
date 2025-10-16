{ pkgs, inputs, lib, ... }:
{
  nixpkgs.config.allowUnfree = true;
  # nixpkgs.overlays = [
  #       (final: prev: {
  #         yandex-music = prev.yandex-music.overrideAttrs (oldAttrs: rec {
  #           version_info = with builtins; fromJSON ''
  #           {
  #               "ym": {
  #                   "version": "5.57.0",
  #                   "exe_name": "Yandex_Music_x64_5.57.0.exe",
  #                   "exe_link": "https://music-desktop-application.s3.yandex.net/stable/Yandex_Music_x64_5.57.0.exe",
  #                   "exe_sha256": "148afbede1f492c2922c32416f24d277f424c1dd5415cfd5149dc61276ce0fdd"
  #               },
  #               "electron": {
  #                   "version": "34.5.8",
  #                   "x64": "https://github.com/electron/electron/releases/download/v34.5.8/electron-v34.5.8-linux-x64.zip",
  #                   "armv7l": "https://github.com/electron/electron/releases/download/v34.5.8/electron-v34.5.8-linux-armv7l.zip",
  #                   "arm64": "https://github.com/electron/electron/releases/download/v34.5.8/electron-v34.5.8-linux-arm64.zip"
  #               }
  #           }
  #           '';
  #             src = prev.yandex-music.override.fetchurl {
  #               url = "https://music-desktop-application.s3.yandex.net/stable/Yandex_Music_x64_5.57.0.exe";
  #               sha256 =  "148afbede1f492c2922c32416f24d277f424c1dd5415cfd5149dc61276ce0fdd";
  #             };
  #           });
  #         yandex-music-custom = final.yandex-music;
  #        })
  #     ];
  #
  home.packages = with pkgs; [
    pulseaudio # For pactl
    filezilla # FTP Client
    btop # System monitor
    firefox # Browser
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
    telegram-desktop # Chat
    discord # Voice chat
    nsxiv # Image viewer
    seafile-client # Cloud
    libnotify # Notify utils
    obsidian # Notes
    hyprshot # Screenshots
    peaclock # cli timer, stopwatch, clock
    taskwarrior3 # cli task manager
    yandex-music-custom
    # libsForQt5.dolphin # File Browser

    # Fonts
    nerd-fonts.symbols-only
    nerd-fonts.agave
    dejavu_fonts
    fira-code
    noto-fonts
    roboto
    roboto-mono
    symbola
];
}
