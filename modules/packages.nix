{
  pkgs,  
  inputs,
  system,
  ...
}:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    dconf
    appimage-run # Needed For AppImage Support
    cliphist # Clipboard manager using rofi menu
    glxinfo # needed for inxi diag util
    greetd.tuigreet # The Login Manager (Sometimes Referred To As Display Manager)
    inxi # CLI System Information Tool
    killall # For Killing All Instances Of Programs
    lm_sensors # Used For Getting Hardware Temps
    pciutils # Collection Of Tools For Inspecting PCI Devices
    pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
    unrar # Tool For Handling .rar Files
    unzip # Tool For Handling .zip Files
    uwsm # Universal Wayland Session Manager (optional must be enabled)
    v4l-utils # Used For Things Like OBS Virtual Camera
    wget # Tool For Fetching Files With Links
    python3
    screen
    openconnect # Vpn client
    jq
    acpi

    # Graphical support
    mesa
    libGL
    vulkan-tools
    vulkan-headers
    vulkan-loader
    vulkan-validation-layers
  ];
}
