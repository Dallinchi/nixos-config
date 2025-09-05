{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  
  home.packages = with pkgs; [
    pulseaudio # For pactl
    filezilla # FTP Client
    alacritty
    ranger
    btop
    openconnect
    firefox
    brightnessctl # For Screen Brightness Control
    ffmpeg # Terminal Video / Audio Editing
    mpv # Incredible Video Player
    pavucontrol # For Editing Audio Levels & Devices
    playerctl # Allows Changing Media Volume Through Scripts
    usbutils # Good Tools For USB Devices
    v4l-utils # Used For Things Like OBS Virtual Camera
    tofi
    swaybg
    
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
