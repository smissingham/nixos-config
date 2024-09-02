{ config, lib, pkgs, modulesPath, ... }:

{
	imports = 
	[
		./nvidia.nix
		./de.nix
	];

	# TOP LEVEL CONFIG
	
	boot.kernelPackages = pkgs.linuxPackages_6_10;
	#boot.kernelModules = [ "ath11k" "ath11k_pci" "ath12k" "ath12k_pci" ];
	hardware.enableAllFirmware = true;
	nixpkgs.config.allowUnfree = true;
	networking.networkmanager.enable = true;
	#hardware.firmware = with pkgs; [
	#	linux-firmware
	#];

	# Extra programs that can't/should'nt install via systemPackages
	services.flatpak.enable = true;
	programs.steam.enable = true; # so far, this is the best option. Flathub version less so, systemPackage version sucks
	programs.firefox.enable = true;

	environment.systemPackages = with pkgs; [
		
		# System Utils
		htop
		pciutils
		wget

		# Media Apps
		spotify

		# Commumincation Apps
		telegram-desktop
		discord

		# Productivity Apps
		obsidian
		libreoffice
		drive # Google Drive Sync

		# Developer applications
		git
		vscode
		# note, jetbrains products via systemPackages don't work. Use toolbox instead
		jetbrains-toolbox 

		# SDKs
		(python311.withPackages (ps: with ps; [
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