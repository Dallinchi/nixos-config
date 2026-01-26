{pkgs, inputs, ... }:

{
  # Configuration files
  xdg.configFile = {
    # Main caelestia shell configuration
    "quickshell/lacrity-space" = {
      source = ./shell;
      recursive = true;
    };
  };

  home.packages = with pkgs; [
    inputs.quickshell.packages.${pkgs.stdenv.hostPlatform.system}.default

    # Qt6 related kits（for slove Qt5Compat problem）
    qt6.qt5compat
    qt6.qtbase
    qt6.qtquick3d
    qt6.qtwayland
    qt6.qtdeclarative
    qt6.qtsvg
 ];

  # necessary environment variables
  home.sessionVariables = {
    QML_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
    QML2_IMPORT_PATH = "${pkgs.qt6.qt5compat}/lib/qt-6/qml:${pkgs.qt6.qtbase}/lib/qt-6/qml";
    QT_QPA_PLATFORM = "wayland;xcb";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
  };
}
