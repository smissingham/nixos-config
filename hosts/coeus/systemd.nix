{
  config,
  pkgs,
  environment,
  ...
}:
{
  
  # ----------- Obsidian Notes > Github Sync ----------- #
  systemd.services."sync-blog" = {
    description = "Obsidian Sync to Github";
    path = with pkgs; [
      bash
      rsync
      git
      openssh
    ];
    environment = config.environment.variables;
    script = "bash $NIX_CONFIG_HOME/scripts/sync-blog.sh";
    serviceConfig = {
      Type = "oneshot";
      User = "smissingham";
    };
  };
  systemd.timers."sync-blog" = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnBootSec = "1h";
      OnUnitActiveSec = "1h";
      Unit = "sync-blog.service";
    };
  };

  # ----------- Filen AutoStart on Logon ----------- #
  systemd.user.services.filen-desktop = {
    description = "Start Filen Desktop Client";
    wantedBy = [ "graphical-session.target" ];
    after = [ "graphical-session.target" ];
    startLimitBurst = 5;
    startLimitIntervalSec = 500;
    serviceConfig = {
      ExecStart = "${pkgs.filen-desktop}/bin/filen-desktop";
      Restart = "on-failure";
      RestartSec = "5s";
    };
  };
}
