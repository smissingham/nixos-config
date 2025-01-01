#!/bin/sh

MOUNT_DIR="/home/smissingham/.ProtonMount"
 
mkdir -p "$MOUNT_DIR"

fusermount -u $MOUNT_DIR &>/dev/null

rm -rf ./rclone.log &>/dev/null

echo "Mounting to $MOUNT_DIR"

rclone mount proton: ${MOUNT_DIR} \
--allow-non-empty \
--vfs-cache-mode full \
--vfs-cache-max-size 100G \
--dir-cache-time 2000h \
--log-level ERROR \
--log-file ./mount.log \
& # run in background

# --vfs-cache-poll-interval 30s \ # doesnt work with proton

echo "Mounted"