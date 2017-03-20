#!/bin/bash
set -e

mkdir /downloads

docker run --rm \
	-e ORACLE_OTN_USER="$ORACLE_OTN_USER" \
	-e ORACLE_OTN_PASSWORD="$ORACLE_OTN_PASSWORD" \
	-v /downloads:/downloads \
	viniciusam/oracle-toolbox -p sqlcl

if [ ! -f /downloads/sqlcl*.zip ]; then
    echo "Error: download file not found..."
    exit 1
fi

exit 0
