{ pkgs, config, ... }:

{
  environment.systemPackages = with pkgs; [
    (writeShellScriptBin "sfx"
    ''
    set -e
    set -u
    set -o pipefail

    exec mpv --really-quiet --no-video "/etc/xdg/dallinchi-sfx/$1.wav" &
    '')

    (writeShellScriptBin "timer"
    ''
    set -e
    set -u
    set -o pipefail

    sleep "$1"
    sfx ringaling
    notify-send 'timer complete' "$1"
    '')
  ];
}

