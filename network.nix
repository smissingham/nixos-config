{
  config,
  pkgs,
  ...
}: {
  # Configure networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [80 443];
    allowedUDPPortRanges = [
      #{ from = 4000; to = 4007; }
      #{ from = 8000; to = 8010; }
    ];

    interfaces."eth0".allowedTCPPorts = [80 443];
    interfaces."podman+".allowedUDPPorts = [53 5353];
  };

  services.fail2ban = {
    enable = true;
    maxretry = 5;
    ignoreIP = [
      # Whitelist
    ];

    bantime = "24h"; # Ban IPs for one day on the first ban
    bantime-increment = {
      enable = true; # Enable increment of bantime after each violation
      formula = "ban.Time * math.exp(float(ban.Count+1)*banFactor)/math.exp(1*banFactor)";
      #multipliers = "1 2 4 8 16 32 64";
      #maxtime = "168h"; # Do not ban for more than 1 week
      overalljails = true; # Calculate the bantime based on all the violations
    };
  };
}
