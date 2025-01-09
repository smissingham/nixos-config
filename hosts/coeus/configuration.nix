{
  pkgs,
  mainUser,
  ...
}:
{
  imports = [
    ../../styles/catppuccin-mocha.nix
    ./hardware.nix
    ./systemd.nix
  ];

  environment.variables = {
    NIX_CONFIG_HOME = "/home/smissingham/Documents/Nix";
  };

  environment.systemPackages = with pkgs; [
    # System Utilities
    v4l-utils
  ];
  home-manager.users.${mainUser.username}.home.packages = with pkgs; [
    floorp

    # Entertainment
    spotify

    # Work
    teams-for-linux

    # Communication
    telegram-desktop
    discord

    # Office
    libreoffice
    obsidian
    thunderbird
    filen-desktop

    # Dev Tools
    kdePackages.kate
    jetbrains-toolbox
    vscode
    gitkraken
    bruno
  ];

  mySystemModules = {
    # Window Manager
    wm.plasma6.enable = true;
    entertainment.gaming.enable = true;

    access = {
      sunshine.enable = true;
      sunshine.withMoonlight = true;
      #tailscale.enable = true;
      #tailscale.authKey = secrets.tailscale.authkey;
    };

    virt = {
      kvm = {
        enable = true;
        withCliTools = true;
        withGuiTools = true;
      };
      podman = {
        enable = true;
        dockerCompat = true;
        withCliTools = true;
        withGuiTools = true;
      };
    };
  };

  # Configure networking
  networking.hostName = "coeus";
  time.timeZone = "America/Chicago";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  hardware.bluetooth.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Prevent all types of suspend/sleep. This is a server, and this only causes graphical issues
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  system.stateVersion = "24.11"; # Did you read the docs?
}
