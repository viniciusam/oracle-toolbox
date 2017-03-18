#!/bin/bash
set -e

########### SIGINT handler ############
function _int() {
   echo "SIGINT received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF
   lsnrctl stop
}
trap _int SIGINT

########### SIGTERM handler ############
function _term() {
   echo "SIGTERM received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown immediate;
   exit;
EOF
   lsnrctl stop
}
trap _term SIGTERM

########### SIGKILL handler ############
function _kill() {
   echo "SIGKILL received, shutting down database!"
   sqlplus / as sysdba <<EOF
   shutdown abort;
   exit;
EOF
   lsnrctl stop
}
trap _kill SIGKILL

# Start the listener and database.
lsnrctl start
sqlplus / as sysdba << EOF
    STARTUP;
    EXIT;
EOF

echo "DATABASE IS READY!"

tail -f $ORACLE_BASE/diag/rdbms/*/*/trace/alert*.log &
childPID=$!
wait $childPID
