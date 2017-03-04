#!/bin/bash
set -e

mkdir -p /xe_logs
INSTALL_LOG=/xe_logs/XEsilentinstall.log
RPM_FILE=oracle-xe-11.2.0-1.0.x86_64.rpm

# Change the reponse file.
sed -i -e "s|###ORACLE_PASSWORD###|$ORACLE_PASSWORD|g" $SCRIPTS_DIR/$INSTALL_RSP

cd $INSTALL_DIR/Disk1

# Remove swap size validation and rebuild the rpm file.
# sed -i -e "s|if \[ \$swapspace -lt \$requiredswapspace \]|if \[ \$swapspace -lt 0 \]|g" $RPM_FILE
# rpmrebuild --edit-pre -p $RPM_FILE

# Create a swap space.
df -h
dd if=/dev/zero of=/swapfile bs=1M count=2200

# Install the database.
rpm -ivh $RPM_FILE >> $INSTALL_LOG
/etc/init.d/oracle-xe configure responseFIle=$SCRIPTS_DIR/$INSTALL_RSP >> $INSTALL_LOG

# Setup environment variables.
/u01/app/oracle/product/11.2.0/xe/bin/oracle_env.sh

# Enable remote access.
sqlplus system/"$ORACLE_PASSWORD" <<SQL
EXEC DBMS_XDB.SETLISTENERLOCALACCESS(FALSE);
EXIT;
SQL

echo "DATABASE IS READY!"

tail -f $INSTALL_LOG & childPID=$!
wait $childPID
