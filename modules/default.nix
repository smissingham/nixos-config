{
  config,
  lib,
  mainUser,
  pkgs,
  system,
  ...
}:
let

  # WIP: a function to auto-set a module's config indentation
  # getModulePath = {}:(
  #     let
  #       moduleTopLevel = "myModules"; # top level config name to contain all modules, eg. `myModules`.wm.plasma6
  #       moduleRootDir = "modules"; # directory where the modules nix configs are contained

  #       modulePath = builtins.elemAt (builtins.split moduleRootDir (builtins.toString ./.)) 2;
  #       modulePathList = builtins.filter (x: builtins.typeOf x == "string" && x != "") (
  #         builtins.split "/" (modulePath)
  #       );
  #       modulePathDots = builtins.concatStringSep "." (moduleTopLevel ++ modulePathList);
  #     in
  #     # Return the final result
  #     modulePathDots;
  # );

in
{

  # TODO implement dynamic discovery of all imports in modules directory
  imports = [
    ./access/sunshine.nix
    ./entertainment/gaming.nix
    ./virt/kvm.nix
    ./virt/podman.nix
    ./wm/plasma6.nix
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
