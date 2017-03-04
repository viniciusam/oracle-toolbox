#!/bin/bash
set -e

export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

chmod -R 777 $SCRIPTS_DIR

if [ ! -d $ORACLE_BASE ]; then

    mkdir -p $ORACLE_BASE
    mkdir -p $ORACLE_INVENTORY
    chown -R oracle:oinstall $ORACLE_BASE
    chown -R oracle:oinstall $ORACLE_INVENTORY
    chmod -R 775 $ORACLE_BASE
    chmod -R 775 $ORACLE_INVENTORY

    sed -i -e "s|###ORACLE_INVENTORY###|$ORACLE_INVENTORY|g" $SCRIPTS_DIR/$INSTALL_RSP
    sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" $SCRIPTS_DIR/$INSTALL_RSP
    sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" $SCRIPTS_DIR/$INSTALL_RSP

    sed -i -e "s|###GDBNAME###|$GDBNAME|g" $SCRIPTS_DIR/$DBCA_RSP
    sed -i -e "s|###ORACLE_SID###|$ORACLE_SID|g" $SCRIPTS_DIR/$DBCA_RSP
    sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" $SCRIPTS_DIR/$DBCA_RSP

    gosu oracle /bin/bash -c "cd $INSTALL_DIR/database && ./runInstaller -silent -force -waitforcompletion -ignoreSysPrereqs -ignorePrereq -showProgress -responseFile $SCRIPTS_DIR/$INSTALL_RSP"
    $ORACLE_INVENTORY/orainstRoot.sh
    $ORACLE_HOME/root.sh

    # Setup the listener and create the database instance.
    gosu oracle /bin/bash -c "netca -silent -responseFile $SCRIPTS_DIR/$NETCA_RSP"
    gosu oracle /bin/bash -c "dbca -silent -responseFile $SCRIPTS_DIR/$DBCA_RSP"

else

    # Remove the listener files to reconfigure using new hostname.
    rm $ORACLE_HOME/network/admin/listener.ora
    rm $ORACLE_HOME/network/admin/sqlnet.ora
    
    # Startup the listenet and the database.
    # TODO: The tns will still have the old hostname, but we won't ned to change it for now.
    gosu oracle /bin/bash -c "netca -silent -responseFile $SCRIPTS_DIR/$NETCA_RSP"
    gosu oracle /bin/bash -c "sqlplus / as sysdba << EOF
        STARTUP;
        EXIT;
EOF"

fi

echo "DATABASE IS READY!"

tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
childPID=$!
wait $childPID
