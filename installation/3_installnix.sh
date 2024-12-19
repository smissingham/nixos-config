#### INSTALL NIXOS FROM LOCAL configuration.nix ####

# Generates configuration.nix and hardware-configuration.nix files
# Useful for first-time generating of hardware
#nixos-generate-config --root /mnt

# Copy configurations and git repo to /etc/nixos
mkdir -p /mnt/etc/nixos
cp -ra ../* /mnt/etc/nixos/

# get the UUID of the earlier created mdadm array
ARRAYUUID=$(mdadm --detail --scan /dev/md0 | grep -o 'UUID=[^ ]*' | cut -d= -f2)

# Use sed to replace the placeholder with the real UUID in the hardware-configuration file
sed -i "s/ARRAYUUID/$ARRAYUUID/" /mnt/etc/nixos/hardware-configuration.nix

# Install NixOS
nixos-install --root /mnt --no-root-passwd

# Set user/root password
nixos-enter --root /mnt -c 'passwd smissingham'
#nixos-enter --root /mnt -c 'passwd root'

# Reboot to the new system
echo "Installation completed. Please reboot your system to start NixOS."
#reboot
