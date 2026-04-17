{
  flake.modules.nixos.scripts = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
      (writeShellScriptBin "sfx"
      ''
      set -e
      set -u
      set -o pipefail

      exec ${lib.getExe (pkgs.mpv)} --really-quiet --no-video "/etc/xdg/dallinchi-sfx/$1.wav" &
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

      (writeShellScriptBin "dvd"
      ''
      echo "use flake \"github:the-nix-way/dev-templates?dir=$1\"" >> .envrc
      direnv allow
      '')

      (writeShellScriptBin "dvt"
      ''
      nix flake init -t "github:the-nix-way/dev-templates#$1"
      direnv allow
      '')
    ];
  };
}

