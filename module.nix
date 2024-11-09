self: pname: {
  config,
  lib,
  ...
}:

with lib;

let
  cfg = config.services.${pname};
in {
  options = {
    services.${pname} = {
      enable = mkEnableOption pname;

      package = mkOption {
        type = types.package;
        default = self.packages.x86_64-linux.default;
      };

      envFile = mkOption {
        type = types.path;
        description = "The path to the env file";
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.services.${pname} = {
      description = "Prometheus Qbittorrent exporter";

      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        ExecStart = "${cfg.package}/bin/qbit-exp -e";
        Restart = "on-failure";
        EnvironmentFile = cfg.envFile;
      };
    };
  };
}
