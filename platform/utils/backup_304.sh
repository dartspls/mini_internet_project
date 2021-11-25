#!/bin/bash
# Backs up the running configuration/groups directory every hour
# Launch the script from the platform directory
# Creates a backups folder two directory levels above, e.g. besides the mini_internet_project folder

backup_dir="../../backups"
# Check if we are running in the correct directory
if [[ ! -d "groups" ]]; then
    echo "Cannot find the groups folder, either:"
    echo "  Run this script from the platform directory"
    echo "  Or, start the mini-internet project"
    exit 1
fi

mkdir -p "$backup_dir"
if [[ ! -d "$backup_dir" ]]; then
    echo "Cannot create the backup directory, exiting"
    exit 1
fi

while true;
do
	tar -cvpzf "$backup_dir/$(date +%Y-%m-%d_%H:%M)-groups.backup.tar.gz" ./groups/

	# Every hour
	sleep 3600
done