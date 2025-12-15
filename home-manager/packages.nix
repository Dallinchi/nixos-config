{ pkgs, inputs, lib, ... }:
{
  home.packages = with pkgs; [
    pulseaudio # For pactl
    filezilla # FTP Client
    btop # System monitor
    #firefox # Browser
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
    yandex-music
    nautilus
    wineWowPackages.stable # support both 32-bit and 64-bit applications
    winetricks # winetricks (all versions)
    vscode # Text editor
    xwayland-satellite # Xwayland for niri 
    chatterino7 # Twitch chat

    gparted

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
