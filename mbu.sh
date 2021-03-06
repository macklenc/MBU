#!/bin/bash

SSH=0

if [ $SSH -eq 1 ]
then
	DEST=$(cat config/back)
	(cd $DEST; bash filemanager.sh -u)
	cp $DEST/list.txt .
else
	DEST=$(cat config/back)
	REMCOM=$(cat config/remcom)
	REMUSR=$(cat config/remusr)

	ssh $REMUSR@$REMCOM "cd $DEST; bash filemanager.sh -u"
	ssh $REMUSR@$REMCOM "cat $DEST/list.txt" | cat > ~/setup/config/backupList.txt
fi
bash setup.sh.base
