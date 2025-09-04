{
  # Git Configuration ( For Pulling Software Repos )
  gitUsername = "Dallinchi";
  gitEmail = "herooopr@gmail.com";

  # Set Displau Manager
  # `tui` for Text login
  # `sddm` for graphical GUI
  # SDDM background is set with stylixImage
  displayManager = "tui";

  # Emable/disable bundled applications
#  tmuxEnable = false;
#  alacrittyEnable = true;
#  weztermEnable = false;
#  ghosttyEnable = false;
#  vscodeEnable = true;
#  helixEnable = false;
  #To install rebuild, then run zcli doom install
#  doomEmacsEnable = false;

  # P10K or starship prompt
#  userPrompt = "starship";

  # Hyprland Settings
  extraMonitorSettings = "";

  # Waybar Settings
#  clock24h = true;

  # Program Options
  browser = "firefox"; # Set Default Browser (google-chrome-stable for google-chrome)
  terminal = "alacritty"; # Set Default System Terminal
  keyboardLayout = "us, ru";
  consoleKeyMap = "us";

  # For Nvidia Prime support
#  intelID = "PCI:1:0:0";
#  nvidiaID = "PCI:0:2:0";

  # Enable NFS
 # enableNFS = true;

  # Enable Printing Support
  #printEnable = false;

  # Enable Thunar GUI File Manager
  # thunarEnable = false;

  # Set Stylix Image
  # This will set your color palette
  # Default background
  # Add new images to ~/zaneyos/wallpapers
  #stylixImage = ../../wallpapers/mountainscapedark.jpg;
  #stylixImage = ../../wallpapers/AnimeGirlNightSky.jpg;
  #stylixImage = ../../wallpapers/Anime-Purple-eyes.png;
  #stylixImage = ../../wallpapers/Rainnight.jpg;
  #stylixImage = ../../wallpapers/zaney-wallpaper.jpg;
  #stylixImage = ../../wallpapers/nix-wallpapers-strips-logo.jpg;
  #stylixImage = ../../wallpapers/beautifulmountainscape.jpg;

  # Set Waybar
  # Available options:
  #waybarChoice= ../../modules/home/waybar/waybar-simple.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-curved.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-jerry.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-ddubs-2.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-dwm.nix;
  #waybarChoice = ../../modules/home/waybar/waybar-dwm-2.nix;

  # Set Animation style
  # Available options are:
  # animations-def.nix  (default)
  # animations-end4.nix (end-4 project)
  # animations-dynamic.nix (ml4w project)
  # animations-moving.nix (ml4w project)
  #animChoice = ../../modules/home/hyprland/animations-end4.nix;
  #animChoice = ../../modules/home/hyprland/animations-def.nix;
  #animChoice = ../../modules/home/hyprland/animations-dynamic.nix;
  #animChoice = ../../modules/home/hyprland/animations-moving.nix;

  # Set network hostId if required (needed for zfs)
  # Otherwise leave as-is
  hostId = "5ab03f50";
}
