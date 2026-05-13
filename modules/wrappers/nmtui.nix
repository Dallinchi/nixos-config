{ inputs, ... }: {
  perSystem = { pkgs, ... }: {
    packages.nmtui = inputs.wrappers.lib.wrapPackage {
        inherit pkgs;
        package = pkgs.networkmanager;
        exePath = "${pkgs.networkmanager}/bin/nmtui";
        binName = "nmtui";
        env = {
          NEWT_COLORS=''
            root=lightgray,black

            window=lightgray,black
            shadow=black,black
            border=gray,black

            title=yellow,black
            textbox=lightgray,black
            roottext=lightgray,black
            label=lightgray,black

            entry=white,black
            disentry=gray,black

            button=black,gray
            compactbutton=lightgray,black

            actbutton=black,yellow
            actsellistbox=black,yellow
            actlistbox=black,black

            listbox=lightgray,black
            sellistbox=white,black

            checkbox=lightgray,black
            actcheckbox=yellow,black

            helpline=gray,black
            roottext=gray,black

            emptyscale=gray,black
            fullscale=yellow,black
          '';
        };
      };
  };
}
