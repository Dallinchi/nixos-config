{ inputs, ...}: {
  perSystem = {pkgs, ...}: let
    
    makePeaclockVariant = name: configText: let
      templateDir = pkgs.runCommand "peaclock-template-${name}" {} ''
        mkdir -p $out/peaclock/history
        cat << 'EOF' > $out/peaclock/config
        ${configText}
        EOF
        touch $out/peaclock/history/command
      '';
    in inputs.wrappers.lib.wrapPackage {
      inherit pkgs;
      package = pkgs.peaclock;
      binName = "peaclock-${name}";
      flags = {
        "--config-dir" = "$PEACLOCK_RUNTIME_CONFIG";
      };

      preHook = ''
        TARGET_BASE="''${XDG_CONFIG_HOME:-$HOME/.config}"
        TARGET_DIR="$TARGET_BASE/peaclock-${name}"

        if [ ! -d "$TARGET_DIR/peaclock" ]; then
          mkdir -p "$TARGET_DIR"
        fi
        cp -r "${templateDir}/peaclock" "$TARGET_DIR/"
        chmod -R u+w "$TARGET_DIR/peaclock"

        export PEACLOCK_RUNTIME_CONFIG="$TARGET_DIR/peaclock"
      '';
    };

    configDefault = ''
      mode clock
      set seconds on
      set date off
      style active-fg #39f7ff
      style inactive-fg clear
      style colon-fg #39f7ff
      style active-bg reverse
    '';

    configTimer = ''
      mode timer
      set seconds on
      set date off
      style active-fg red
      style inactive-fg clear
      style colon-fg red
      style active-bg reverse
    '';

    configStopwatch = ''
      mode stopwatch
      stopwatch start
      set seconds on
      set date off
      style active-fg green
      style inactive-fg clear
      style colon-fg green
      style active-bg reverse
    '';

  in {
    packages = {
      peaclock = makePeaclockVariant "clock" configDefault;
      peaclock-timer = makePeaclockVariant "timer" configTimer;
      peaclock-stopwatch = makePeaclockVariant "stopwatch" configStopwatch;
    };
  };
}

