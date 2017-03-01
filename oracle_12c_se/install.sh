#!/bin/bash
set -e

export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

mkdir -p $ORACLE_BASE
chown -R oracle:oinstall $ORACLE_BASE
chmod -R 775 $ORACLE_BASE

# Install Reponse File
sed -i -e "s|###ORACLE_INVENTORY###|$ORACLE_INVENTORY|g" $SCRIPTS_DIR/$INSTALL_RSP
sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" $SCRIPTS_DIR/$INSTALL_RSP
sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" $SCRIPTS_DIR/$INSTALL_RSP

# Config Reponse File
sed -i -e "s|###GDBNAME###|$GDBNAME|g" $SCRIPTS_DIR/$DBCA_RSP
sed -i -e "s|###ORACLE_SID###|$ORACLE_SID|g" $SCRIPTS_DIR/$DBCA_RSP
sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" $SCRIPTS_DIR/$DBCA_RSP

# Install
gosu oracle /bin/bash -c "cd $INSTALL_DIR/database && ./runInstaller -silent -force -waitforcompletion -ignoreSysPrereqs -ignorePrereq -showProgress -responseFile $SCRIPTS_DIR/$INSTALL_RSP"
$ORACLE_INVENTORY/orainstRoot.sh
$ORACLE_HOME/root.sh

# Create the Database
gosu oracle /bin/bash -c "netca -silent -responseFile $SCRIPTS_DIR/$NETCA_RSP"
gosu oracle /bin/bash -c "dbca -silent -responseFile $SCRIPTS_DIR/$DBCA_RSP"

echo "DATABASE IS READY!"

tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
childPID=$!
wait $childPID
