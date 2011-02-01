#!/bin/sh
if ps -x | grep -v grep | grep Google\ Chrome > /dev/null; then
	echo "Close Chrome and try again..."
	exit 1
fi

read -p "This will overwrite your Google Chrome search engines! Are you sure?  " -n 1
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
	echo "Cancelling operation."
	exit 1
fi

SOURCE=${1:-./keywords.sql}
TEMP_SQL_SCRIPT=/tmp/sync_chrome_sql_script
echo
echo "Importing Chrome keywords from $SOURCE..."
cd ~/Library/Application\ Support/Google/Chrome/Default
echo DROP TABLE IF EXISTS keywords\; > $TEMP_SQL_SCRIPT
echo .read $SOURCE >> $TEMP_SQL_SCRIPT
cp -f "Web Data" "Web Data.backup"
sqlite3 -init $TEMP_SQL_SCRIPT Web\ Data .exit
rm $TEMP_SQL_SCRIPT
