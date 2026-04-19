{
  flake.modules.nixos.b4-container = {

    environment.etc."b4".source = ./config;

    virtualisation.podman.enable = true;

    virtualisation.oci-containers = {
      backend = "podman";

      containers.b4 = {
        image = "lavrushin/b4:latest";

        extraOptions = [
          "--network=host"
          "--cap-add=NET_ADMIN"
          "--cap-add=NET_RAW"
          "--cap-add=SYS_MODULE"
        ];

        volumes = [
          "/etc/b4:/etc/b4"
        ];

        cmd = [
          "--config"
          "/etc/b4/b4.json"
        ];

        autoStart = true;
      };
    };
  };
}
