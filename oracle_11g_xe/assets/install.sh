#!/bin/bash
set -e

cp $ASSETS_DIR/tmpl_xe.rsp $ASSETS_DIR/xe.rsp
INSTALL_RSP=$ASSETS_DIR/xe.rsp

sed -i -e "s|###ORACLE_PASSWORD###|$ORACLE_PASSWORD|g" $SCRIPTS_DIR/$INSTALL_RSP

cd $INSTALL_DIR/Disk1

# Install the database.
rpm -ivh oracle-xe-11.2.0-1.0.x86_64.rpm
/etc/init.d/oracle-xe configure responseFile=$SCRIPTS_DIR/$INSTALL_RSP

rm -f $INSTALL_RSP

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
