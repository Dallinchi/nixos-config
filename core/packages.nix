{
  pkgs,
  pkgs-unstable,
  inputs,
  system,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.dconf
    pkgs.appimage-run # Needed For AppImage Support
    pkgs.cliphist # Clipboard manager using rofi menu
    pkgs.glxinfo # needed for inxi diag util
    pkgs.greetd.tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    pkgs.inxi # CLI System Information Tool
    pkgs.killall # For Killing All Instances Of Programs
    pkgs.lm_sensors # Used For Getting Hardware Temps
    pkgs.pciutils # Collection Of Tools For Inspecting PCI Devices
    pkgs.pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    pkgs.unrar # Tool For Handling .rar Files
    pkgs.unzip # Tool For Handling .zip Files
    pkgs.uwsm # Universal Wayland Session Manager (optional must be enabled)
    pkgs.v4l-utils # Used For Things Like OBS Virtual Camera
    pkgs.wget # Tool For Fetching Files With Links
    pkgs.python3
    pkgs.screen
    pkgs.openconnect # Vpn client
    
    # Graphical support
    pkgs.mesa
    pkgs.libGL
    pkgs.vulkan-tools
    pkgs.vulkan-headers
    pkgs.vulkan-loader
    pkgs.vulkan-validation-layers
  ];
}
