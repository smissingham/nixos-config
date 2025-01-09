{
  mainUser,
  pkgs,
  ...
}:
{

  # TODO implement dynamic discovery of all imports in modules directory
  imports = [
    ./home-manager/browsers/floorp.nix

    ./system/coding/vscodium.nix
    ./system/access/sunshine.nix
    ./system/entertainment/gaming.nix
    ./system/virt/kvm.nix
    ./system/virt/podman.nix
    ./system/wm/gnome-xserver.nix
    ./system/wm/plasma6.nix
  ];

  #----- DEFAULTS TO APPLY ON ALL SYSTEMS -----#
  environment.systemPackages = with pkgs; [
    # SYSTEM UTILITIES
    #agenix
    git
    rclone
    btop
    dnsutils
    pciutils
    usbutils
    nixfmt-rfc-style

    # DEVTOOLS
    nil # nix LSP
    direnv # for vscode explorer
  ];

  networking = {
    firewall.enable = true;
    networkmanager.enable = true;
  };

  # TODO extract to module
  networking.firewall.allowedTCPPorts = [ 22 ];
  services.openssh = {
    enable = true;
    ports = [ 22 ];
    settings = {
      PasswordAuthentication = true;
      AllowUsers = [ mainUser.username ];
      UseDns = true;
    };
  };

  # TODO extract to module
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

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      filen-desktop = pkgs.callPackage ../packages/filen-desktop.nix { };
    };
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };
}
