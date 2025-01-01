#!/bin/sh

rclone sync /home/smissingham proton:/Backups/TANK-NixOS \
    --progress \
    --filter-from ./sync-filter.txt \
    --protondrive-replace-existing-draft=true \
#    &>./sync-log.log

#    --verbose \
#    --dry-run \

echo "Sync Finished"