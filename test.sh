#!/bin/bash
set -e

DOWNLOADS_DIR=$HOME/downloads
mkdir $DOWNLOADS_DIR

docker run --rm \
	-e ORACLE_OTN_USER="$ORACLE_OTN_USER" \
	-e ORACLE_OTN_PASSWORD="$ORACLE_OTN_PASSWORD" \
	-v $DOWNLOADS_DIR:/downloads \
	viniciusam/oracle-toolbox -p sqlcl

if [ ! -f $DOWNLOADS_DIR/sqlcl*.zip ]; then
    echo "Error: downloaded file not found..."
    exit 1
fi

exit 0
