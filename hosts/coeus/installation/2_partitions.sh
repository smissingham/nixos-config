#### CREATE PARTITIONS ON BLANK DISKS ####
for drive in /dev/nvme{0..3}n1; do
		
	# Create GPT partition tables
	parted -s "$drive" mklabel gpt
	
	# Create 2GB EFI partition
	parted -s "$drive" mkpart EFI fat32 1MiB 2049MiB
	parted -s "$drive" set 1 boot on

 	# Create Primary partition on remainder of disk
	parted -s "$drive" mkpart primary 2049MiB 100%

 	# Write a FAT32 FS to the EFI partition
	mkfs.fat -F 32 "$drive"p1
 
done

#### CREATE LINUX MD RAID 10 ARRAY ####
mdadm --create --verbose /dev/md0 --level=10 --raid-devices=4 /dev/nvme{0..3}n1p2
echo "Waiting for raid array to initialize"
while [ "$(cat /proc/mdstat | grep -c "resync = ")" -eq 0 ]; do
	sleep 3
done
echo "Array initialized"

#### PRINT RESULTS TO SCREEN ####
lsblk
cat /proc/mdstat

#### CREATE ENCRYPTED LUKS VOLUME ####
cryptsetup --verbose --verify-passphrase luksFormat /dev/md0
cryptsetup luksOpen /dev/md0 luksraid

#### PUT FILESYSTEM ON LUKS AND MOUNT IT TO MNT ROOT ####
mkfs.ext4 /dev/mapper/luksraid
mkdir /mnt
mount /dev/mapper/luksraid /mnt

#### MOUNT BOOT PARTITIONS ####
for i in {0..3}; do
	mkdir -p /mnt/boot$((i+1))
 	mount /dev/nvme"$i"n1p1 /mnt/boot$((i+1))
done

#### PRINT MOUNTS TO SCREEN ####
df -h | grep /mnt
