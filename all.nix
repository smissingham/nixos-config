{ config, lib, pkgs, modulesPath, ... }:

{
	
	# START WIFI SUPPORT

	boot.kernelPackages = pkgs.linuxPackages_6_10;
	
	boot.kernelModules = [ "ath11k" "ath11k_pci" ];
	
	hardware.enableAllFirmware = true;
	
	nixpkgs.config.allowUnfree = true;
	
	hardware.firmware = with pkgs; [
		linux-firmware
	];
	
	# Option 1: Using NetworkManager
	networking.networkmanager.enable = true;

	# END WIFI SUPPORT

	imports = 
	[
		./nvidia.nix
	];

	services.flatpak.enable = true;

	environment.systemPackages = with pkgs; [
		
		# System Utils
		htop
		pciutils
		wget

		# General Purpose Apps
		#steam # installing on flathub instead
		spotify
		obsidian
		telegram-desktop
		discord

		# General Productivity
		libreoffice
		drive #Google Drive Sync

		# Work related
		onedrive

		# Support PWAsForFirefox Extension
		pkgs.firefoxpwa

		# Developer applications
		git
		jetbrains-toolbox
		#jetbrains.dataspell
		#jetbrains.idea-ultimate

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

	programs.firefox = {
		enable = true;
		package = pkgs.firefox;
		nativeMessagingHosts.packages = [ pkgs.firefoxpwa ];
	};
}
