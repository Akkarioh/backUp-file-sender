#!/bin/bash

#check to see if rsync is installed.
if ! command -v rsync > /dev/null 2>&1
then
    echo "this script requires rsync to be installed."
    echo "please use your distributions package manager to install it and try again"
    exit 2
fi

my_dir=$(dirname "$0")

#capture the current date, and store it in the format yyy-mm-dd
current_date=$(date +%Y-%m-%d)

rsync_options="-avb --backup-dir $2/$current_date --delete" #--dry-run removed for testing

$(which rsync) $rsync_options $my_dir/*.log  $PI_USER@$PI_HOST:"$PI_PATH" >> backup_$current_date.log 

#it creates a current directory inside
#target directory to confirm that is the last recent version of the backup.
