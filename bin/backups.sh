DAY=`date +%d`
DATE=`date +%D`
DEST=/backups/Linux/cen7/`uname -n`

ls /backups > /dev/null 2>&1
#mount | grep -q \/backups || exit 1

if [[ ! -d $DEST ]]
then
	echo "$DEST does not exist"
	exit 1
fi

if [[ ! -d /tmp/backups ]]
then
	mkdir /tmp/backups
fi

if [[ -f /tmp/.lastbackup ]]
then
	LASTBACK=`cat /tmp/.lastbackup`
	date "+%D %T"  > /tmp/.lastbackup
else
	echo "/tmp/.lastbackup doesn't exist - aborting"
	exit 1
fi
if [[ $DAY = "01" ]]
then
	#FLAGS="--exclude-from=/home/ksquires/etc/backups.excl -zcvf"
	FLAGS="--exclude-from=/home/ksquires/etc/backups.excl -jcvf"
else
	#FLAGS="--exclude-from=/home/ksquires/etc/backups.excl --after-date=$LASTBACK -zcvf"
	FLAGS="--exclude-from=/home/ksquires/etc/backups.excl --after-date=$LASTBACK -jcvf"
fi

echo "tar $FLAGS $DEST/backups.$DAY.tbz /minecraft /run /etc /var /home /boot 2>/dev/null|mail -s '$(hostname -s) backups `date +\%D`' ksquires@gmail.com"|at 00:00

#echo "tar -tzvf $DEST/backups.$DAY.tgz > /tmp/backups/backups.$DAY.out"|at 03:00
echo "tar -jtvf $DEST/backups.$DAY.tbz > /tmp/backups/backups.$DAY.out"|at 03:00

