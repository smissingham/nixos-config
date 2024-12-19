#!/bin/sh
set -e
pushd ~/Documents/nixos-config &>/dev/null

# auto-format nix files
# capture errors for print but suppress the extra junk
echo "Formatting nix files"
for i in *.nix; do
  [ -f "$i" ] || break
  if ! out=$(alejandra "$i" 2>&1) && [ -n "$out" ]; then
    echo "$out" | grep -v "Checking" | grep -v -e '^$'
  fi
done

#  delete contents of /etc/nixos, copy only .nix files to over,  preserving folders
sudo rm -rf /etc/nixos/*
sudo rclone sync --include "*.nix" . /etc/nixos

# get the UUID of the earlier created mdadm array
ARRAYUUID=$(sudo mdadm --detail --scan /dev/md0 | grep -o 'UUID=[^ ]*' | cut -d= -f2)

# Use sed to replace the placeholder with the real UUID in the hardware-configuration file
sudo sed -i "s/ARRAYUUID/$ARRAYUUID/" /etc/nixos/hardware-configuration.nix


git --no-pager diff -U0 *.nix
echo "NixOS Rebuilding..."

sudo nixos-rebuild switch &>nixos-switch.log || (
cat nixos-switch.log | grep --color error && false)

echo "Committing to Repo"
generation=$(nixos-rebuild list-generations | grep current)


git add .
git commit -m "$generation"

popd