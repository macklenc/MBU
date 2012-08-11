#!/bin/bash
#
#
# each_dir_under_here Space delimited list of directories to backup.  If 
#     multiple directories are listed use quotes around the argument.
# dump_to The directory to save files to.
# [key] An optional parameter (hostname is used if not specified) that is 
#     used to name the backup files.  Particularly necessary if you have 
#     multiple computers backing up to the same dump_to path.
set -x
SSH=0
DIRECTORIES="/home/chris"
BACKUPDIR="/home/macklenc/backup"
REMOTECOM=enterprise
REMOTECOMS=${REMOTECOM:-"localhost"}
REMOTEUSER=macklenc

monthly=1
monthlyInc=0

weekly=0
weeklyInc=0
weeklyDiff=1

daily=0
dailyInc=0
dailyDiff=1

hourly=0
hourlyInc=0
hourlyDiff=1

COMPUTER=$(cat config/host)


PATH=/usr/local/bin:/usr/bin:/bin
DOW=`date +%a`              # Day of the week e.g. Mon
DOM=`date +%d`              # Date of the Month e.g. 27
DM=`date +%d%b`             # Date and Month e.g. 27Sep
DAT=$(date +%Y-%m-%d)
TIME=$(date +%H)

#monthly - keep all
#monthlyInc - Overwrite monthly
#monthlyDiff - Keep for specified duration

mkdir -p $BACKUPDIR/$COMPUTER

monthlyF() {
	month="$DM-full.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$month" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$month $DIRECTORIES 
	fi
}

monthlyIncF() {
	monthi="monthly-full-inc.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$monthi" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$monthi $DIRECTORIES 
	fi
}

weeklyF() {
	week="$DM-weekly.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='week ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$week" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$week $DIRECTORIES --newer-mtime='week ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "false" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/weeklydiff.dat"
	else
		echo "false" | cat > $BACKUPDIR/$COMPUTER/weeklydiff.dat
	fi
}

weeklyIncF() {
	weeki="weekly-inc.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='week ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$weeki" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$weeki $DIRECTORIES --newer-mtime='week ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "false" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/weeklydiff.dat"
	else
		echo "false" | cat > $BACKUPDIR/$COMPUTER/weeklydiff.dat
	fi
}

weeklyDiffF() {
	weekd="weekly-diff-$DM.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='week ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$weekd" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$weekd $DIRECTORIES --newer-mtime='week ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "true" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/weeklydiff.dat"
	else
		echo "true" | cat > $BACKUPDIR/$COMPUTER/weeklydiff.dat
	fi
}

dailyF() {
	day="$DM-daily.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='day ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$day"
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$day $DIRECTORIES --newer-mtime='day ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "false" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/dailydiff.dat"
	else
		echo "false" | cat > $BACKUPDIR/$COMPUTER/dailydiff.dat
	fi
}

dailyIncF() {
	dayi="daily-inc.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='day ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$dayi"
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$dayi $DIRECTORIES --newer-mtime='day ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "false" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/dailydiff.dat"
	else
		echo "false" | cat > $BACKUPDIR/$COMPUTER/dailydiff.dat
	fi
}

dailyDiffF() {
	dayd="daily-diff-$DM.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='day ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$dayd"
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$dayd $DIRECTORIES --newer-mtime='day ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "true" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/dailydiff.dat"
	else
		echo "true" | cat > $BACKUPDIR/$COMPUTER/dailydiff.dat
	fi
}

hourlyF() {
	hour="$DM-hourly-$(date +%H).tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='hour ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$hour" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$hour $DIRECTORIES --newer-mtime='hour ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "false" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/hourlydiff.dat"
	else
		echo "false" | cat > $BACKUPDIR/$COMPUTER/hourlydiff.dat
	fi
}

hourlyincF() {
	houri="hourly-$(date +%H)-inc.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='hour ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$houri" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$houri $DIRECTORIES --newer-mtime='hour ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "false" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/hourlydiff.dat"
	else
		echo "false" | cat > $BACKUPDIR/$COMPUTER/hourlydiff.dat
	fi
}

hourlyDiffF() {
	hourd="$DM-hourly-$(date +%H)-diff.tar"
	if [ $SSH -eq 0 ]
	then
		tar -a -c -f - $DIRECTORIES --newer-mtime='hour ago' | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER-$hourd" 
	else
		tar -a -c -f $BACKUPDIR/$COMPUTER-$hourd $DIRECTORIES --newer-mtime='hour ago' 
	fi

	if [ $SSH -eq 0 ]
	then
		echo "true" | ssh $REMOTEUSER@$REMOTECOM "cat > $BACKUPDIR/$COMPUTER/hourlydiff.dat"
	else
		echo "true" | cat > $BACKUPDIR/$COMPUTER/hourlydiff.dat
	fi
}

if [[ $(date +%M) == "00" || $1 == "-h" ]]
then
	if [ $hourly -eq 1 ]; then
		hourlyF
	elif [ $hourlyInc -eq 1 ]; then
		hourlyIncF
	elif [ $hourlyDiff -eq 1 ]; then
		hourlyDiffF
	fi
fi

if [ $TIME == "00" ]
then
	{
		if [ $daily -eq 1 ]; then
			dailyF
		elif [ $dailyInc -eq 1 ]; then
			dailyIncF
		elif [ $dailyDiff -eq 1 ]; then
			dailyDiffF
		fi

		if [ $DOW == "Sat" ]; then
			{			
				if [ $weekly -eq 1 ]; then
					weeklyF
				elif [ $weeklyInc -eq 1 ]; then
					weeklyIncF
				elif [ $weeklyDiff -eq 1 ]; then
					weeklyDiffF
				fi
				
				if [ $DOM == "01" ]; then
					if [ $monthly -eq 1 ]; then
						monthlyF
					elif [ $monthlyInc -eq 1 ]; then
						monthlyIncF
					fi
				fi
			}
		fi
	}
fi

if [ $SSH -eq 1 ]
then
	(cd $BACKUPDIR; bash filemanager.sh)
else
	ssh $REMOTEUSER@$REMOTECOM "cd $BACKUPDIR; bash filemanager.sh"
fi
