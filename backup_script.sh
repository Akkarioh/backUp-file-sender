#!/bin/bash


# check if rsync is installed
if ! command -v rsync > /dev/null 2>&1
then
    echo "this script requires rsync to be installed."
    echo "please use your distributions package manager to install it and try again"
    exit 1
fi

# using dirname to use the directory where the script currently is
script_dir=$(dirname "$0") 

# env file to store enviroment variables for the script and crontab to use
source $script_dir/backup.env

# capture the current date, and store it in the format yyy-mm-dd
current_date=$(date +%Y-%m-%d)

# differents option for the rsync. this one moves it in a folder with the current date and without deleting the source files
rsync_options="-avb --backup-dir $current_date --delete"

# it removes the source file from the source directory after transfer
rsync_transfer="-av --remove-source-files"


# commands rsync to transfer the specific files to back up and send all output to a log. 
# the log stores in the tmp directory until they are transfer to the target directory
$(which rsync) $rsync_options "$1" $PI_USER@$PI_HOST:"$PI_PATH"/BackUp-Morgoth >> /tmp/backup_$current_date.log

# then transfer that log file to the pi server as well. 
$(which rsync) $rsync_transfer /tmp/backup_$current_date.log $PI_USER@$PI_HOST:"$PI_PATH"/BackUp-Morgoth/backup_$current_date.log 


echo "Backup completed successfully on $current_date"
echo "Source directory: $1"
echo "Target: $PI_USER@$PI_HOST:$PI_PATH/BackUp-Morgoth"
echo "Log file: backup_$current_date.log"
