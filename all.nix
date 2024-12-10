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
  latest-beta =
    # 24.11
    import
    (builtins.fetchTarball https://github.com/NixOS/nixpkgs/archive/refs/tags/24.11-beta.tar.gz)
    # reuse the current configuration
    {config = config.nixpkgs.config;};
in {
  imports = [
    ./de.nix
    ./hardware.nix
    ./homemanager.nix
    ./nvidia.nix
    ./services.nix
    ./webcam.nix
    ./docker.nix
  ];

  # TOP LEVEL CONFIG
  nixpkgs.config.allowUnfree = true;
  #boot.kernelPackages = pkgs.linuxPackages_zen;

  # NETWORKING
  #networking.wireless = {
  #  enable = true;
  #  userControlled.enable = true;
  #  networks = {
  #    ${envVariables.wifi.ssid} = {
  #      psk = envVariables.wifi.password;
  #    };
  #  };
  #};

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Extra programs that can't/should'nt install via systemPackages
  services.flatpak.enable = true;
  programs.steam.enable = true; # so far, this is the best option. Flathub version less so, systemPackage version sucks
  programs.firefox.enable = true;
  programs.dconf.enable = true; # https://github.com/NixOS/nixpkgs/issues/207339#issuecomment-1747101887

  environment.systemPackages = with pkgs; [
    # System Utils
    git
    rclone
    htop
    pciutils
    wget
    alejandra # nix code formatter
    home-manager

    # Entertainment
    spotify
    xboxdrv # controller driver

    floorp # web browser

    # Commumincation Apps
    telegram-desktop
    discord
    zoom-us

    # Productivity Apps
    libreoffice
    obsidian
    pandoc # pdf export support for obsidian
    texliveTeTeX # pdf export support for obsidian
    google-drive-ocamlfuse
    shutter # snipping tool
    ente-auth

    # extra web browsers
    chromium
    microsoft-edge

    # Developer applications
    git
    vscode
    latest-beta.zed-editor
    gitkraken
    bruno
    jetbrains-toolbox

    # SDKs

    # --- Python ---
    # binary installs to /run/current-system/sw/bin/python
    (python311.withPackages (ps:
      with ps; [
        numpy # these two are
        scipy # probably redundant to pandas
        pandas
        polars
        duckdb
        statsmodels
        scikitlearn

        openpyxl # pandas xlsx reader
        xlsx2csv # polars xlsx reader-
        pyarrow # polars pivot

        pip
        jupyter
        jupyterlab
        ipykernel
        nbconvert
        nbformat

        # visualization
        plotly
        matplotlib
        seaborn
      ]))

    # --- NodeJS ---
    nodejs_20
    corepack_20
  ];
}
