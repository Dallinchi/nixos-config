
{
  flake.modules.nixos.nixos = {pkgs, ...}: {

    nixpkgs.config.allowUnfree = true;

    environment.systemPackages = with pkgs; [
      dconf
      mesa-demos # needed for inxi diag util 
      inxi # CLI System Information Tool
      killall # For Killing All Instances Of Programs
      lm_sensors # Used For Getting Hardware Temps
      pciutils # Collection Of Tools For Inspecting PCI Devices
      pkg-config # Wrapper Script For Allowing Packages To Get Info On Others
      unrar # Tool For Handling .rar Files
      unzip # Tool For Handling .zip Files
      wget # Tool For Fetching Files With Links
      python3
      screen
      openconnect # Vpn client
      jq
      acpi
      via
      dhcpcd
      docker-compose # Podman compose compatable
      git
    ];
  
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      nerd-fonts.agave
      nerd-fonts.fira-code
      dejavu_fonts
      fira-code
      noto-fonts
      roboto
      roboto-mono
      symbola
    ];
  };

}
