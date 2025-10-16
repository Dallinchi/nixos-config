{pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.dolphin
    kdePackages.kdegraphics-thumbnailers
    libsForQt5.ffmpegthumbs
    kdePackages.qtsvg
    libsForQt5.kio-extras
  ];

  home.sessionVariables = {
    QT_QPA_PLATFORM = "wayland";
    QT_QPA_PLATFORMTHEME = "qt5ct";
  };
}
