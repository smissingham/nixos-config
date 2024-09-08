{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}: let
  envVariables = lib.importTOML ./env.toml;
  unstable =
    import
    (builtins.fetchTarball https://github.com/nixos/nixpkgs/tarball/nixos-unstable)
    # reuse the current configuration
    {config = config.nixpkgs.config;};
in {
  imports = [
    ./homemanager.nix
    ./nvidia.nix
    ./de.nix
    ./webcam.nix
  ];

  # TOP LEVEL CONFIG
  nixpkgs.config.allowUnfree = true;
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  # NETWORKING
  networking.wireless = {
    enable = true;
    userControlled.enable = true;
    networks = {
      ${envVariables.wifi.ssid} = {
        psk = envVariables.wifi.password;
      };
    };
  };

  # Extra programs that can't/should'nt install via systemPackages
  services.flatpak.enable = true;
  programs.steam.enable = true; # so far, this is the best option. Flathub version less so, systemPackage version sucks
  programs.firefox.enable = true;
  programs.dconf.enable = true; # https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1747101887

  # Podman container config: https://nixos.wiki/wiki/Podman
  # Enable common container config files in /etc/containers
  # virtualisation.containers.enable = true;
  # virtualisation = {
  #   podman = {
  #     enable = true;

  #     enableNvidia = true;

  #     # Create a `docker` alias for podman, to use it as a drop-in replacement
  #     dockerCompat = true;

  #     # Required for containers under podman-compose to be able to talk to each other.
  #     defaultNetwork.settings.dns_enabled = true;
  #   };
  # };

  environment.systemPackages = with pkgs; [
    # Container management apps
    #dive # look into docker image layers
    #podman-tui # status of containers in the terminal
    #docker-compose # start group of containers for dev
    #podman-compose # start group of containers for dev
    #unstable.nvidia-container-toolkit # nvidia gpu support in containers
    nvidia-podman

    # System Utils
    git
    htop
    pciutils
    wget
    alejandra # nix code formatter

    # Media Apps
    spotify

    # Commumincation Apps
    telegram-desktop
    discord

    # Productivity Apps
    libreoffice
    obsidian
    google-drive-ocamlfuse

    # create virtual webcams
    #pkgs.linuxKernel.packages.linux_zen.akvcam

    # Developer applications
    git
    vscode
    # unstable.zed-editor # ironically, terribly slow. Probably just needs better nix support
    # note, jetbrains products via systemPackages don't work. Use toolbox instead
    jetbrains-toolbox

    # SDKs
    (python311.withPackages (ps:
      with ps; [
        numpy # these two are
        scipy # probably redundant to pandas
        jupyterlab
        pandas
        polars
        duckdb
        statsmodels
        scikitlearn
      ]))
  ];
}
