# Welcome to Sean Missingham's PC Configuration Repo

I use this repo to maintain the hardware and OS configuration of my daily-driver desktop, which also acts as a home server.

I use NixOS for the operating system, and host many docker container services. 

All of the configuration for that is declarative, and version controlled, right here in this repo.


# Installation

## PreRequisites
- Download and boot NixOS Minimal installer
- Working internet connection (ethernet is easiest)

## Once booted to minimal installer
- `git clone --depth=1 https://github.com/smissingham/nixos-config`
- `cd ./nixos-config/installation/`
- `sudo bash 0_all.sh`
- Prompt for `YES` to permit overwrite contents of md0
- Prompt (twice) for LUKS passphrase
- Prompt again to open LUKS
- Wait for NixOS installation to finish
- Prompt for user password
- `sudo reboot`
- Optionally, set root passwd (after login is easier)

# Post-Installation
- clone repo contents to ~/Documents/NixOS
- From now on, use `nxrebuild` to copy config from home dir to `/etc/nixos` (or manually `bash ~/Documents/NixOS/_rebuild.sh`)
- When desired, `git push` to push the auto-generated commits up to github master
