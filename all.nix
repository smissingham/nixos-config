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

  environment.systemPackages = with pkgs; [
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

    # Sysadmin Apps
    podman
    podman-desktop

    # manage webcam settings
    #webcamoid

    # create virtual webcams
    #pkgs.linuxKernel.packages.linux_zen.akvcam

    # Developer applications
    git
    vscode
    unstable.zed-editor
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
