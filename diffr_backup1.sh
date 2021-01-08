#/bin/sh
# Set a path to dir with backups (where needs to save a backup)
BACKUP=/home/usr1/backup

# Get a number of day of week
DAY_NUM=$(date +%u)

# Delete current metadata
rm -rf $BACKUP/diffr_bkp.snar


# if day is Sunday - delete  file metadata and archives
if [ "$DAY_NUM" = "7"  ]; then
    NUM="0"
    rm -rf $BACKUP/diffr_bkp.snar0
    rm -rf $BACKUP/*.tgz
else
    NUM="$DAY_NUM"
fi

# if exists original metadata - copy them.
if [ -f "$BACKUP/diffr_bkp.snar0" ]; then
    cp $BACKUP/diffr_bkp.snar0  $BACKUP/diffr_bkp.snar
fi

# Create archive
tar --create \
    --gzip \
    --file=$BACKUP/diffr_bkp.$NUM.tgz \
    --ignore-failed-read \
    --listed-incremental=$BACKUP/diffr_bkp.snar \
    /root \
    /usr \
    /var

# if day is Sunday - create original metadata copy
if [ "$DAY_NUM" = "7" ]; then
    cp $BACKUP/diffr_bkp.snar $BACKUP/diffr_bkp.snar0
fi

# Absolute path to script
SCRIPT_PATH=$(realpath $0)

# Lets's add this script to cron
# this backup should run at 2am of night
# minute(0-59), hour(0-23), dayofmonth(1-31), month(1-12), dayofweek(0-7(0 or 7 is Sunday))
CRON_FILE_PATH='/etc/cron.d/diffr_backup1_02aaa'

if [ -f $CRON_FILE_PATH ]; then
    echo "A file $CRON_FILE_PATH exists."
else
    echo "A file $CRON_FILE_PATH doesn't exist, so let's create it."
    touch /etc/cron.d/diffr_backup1_02aaa
    chmod +x  /etc/cron.d/diffr_backup1_02aaa
fi

echo -e "0   2   *   *   *   $SCRIPT_PATH" >> /etc/cron.d/diffr_backup1_02aaa

systemctl restart crond
