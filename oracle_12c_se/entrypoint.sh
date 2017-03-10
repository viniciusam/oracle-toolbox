#!/bin/bash
set -e

export INSTALL_DIR=/install
export ASSETS_DIR=/assets
chmod -R 775 $ASSETS_DIR

export ORACLE_BASE=/u01/oracle
export ORACLE_INVENTORY=/u01/oraInventory

export ORACLE_HOME=$ORACLE_BASE/product/12.1.0.2/dbhome_1
export ORACLE_HOME_LISTNER=$ORACLE_HOME

export PATH=/usr/sbin:$PATH
export PATH=$ORACLE_HOME/bin:$PATH
export LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib
export CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

if [ ! -d $ORACLE_HOME ]; then
    $ASSETS_DIR/install.sh
    $ASSETS_DIR/create_db.sh
else
    lsnrctl start
    gosu oracle /bin/bash -c "sqlplus / as sysdba << EOF
    STARTUP;
    EXIT;
EOF"
fi;

########### SIGINT handler ############
function _int() {
   echo "SIGINT received, shutting down database!"
   gosu oracle /bin/bash -c "sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF"
   lsnrctl stop
}
trap _int SIGINT

########### SIGTERM handler ############
function _term() {
   echo "SIGTERM received, shutting down database!"
   gosu oracle /bin/bash -c "sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF"
   lsnrctl stop
}
trap _term SIGTERM

########### SIGKILL handler ############
function _kill() {
   echo "SIGKILL received, shutting down database!"
   gosu oracle /bin/bash -c "sqlplus / as sysdba <<EOF
   shutdown abort;
   exit;
EOF"
   lsnrctl stop
}
trap _kill SIGKILL

echo "DATABASE IS READY!"

tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
childPID=$!
wait $childPID
