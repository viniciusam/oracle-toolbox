#!/bin/bash
set -e

DBCA_RSP=dbca.rsp
NETCA_RSP=netca.rsp

sed -i -e "s|###ORACLE_PDB###|$ORACLE_PDB|g" $ASSETS_DIR/$DBCA_RSP
sed -i -e "s|###ORACLE_SID###|$ORACLE_SID|g" $ASSETS_DIR/$DBCA_RSP
sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" $ASSETS_DIR/$DBCA_RSP

mkdir -p $ORACLE_HOME/network/admin

echo "NAME.DIRECTORY_PATH= {TNSNAMES, EZCONNECT, HOSTNAME}" > $ORACLE_HOME/network/admin/sqlnet.ora

echo "LISTENER = 
(DESCRIPTION_LIST = 
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521)) 
  ) 
) 
" > $ORACLE_HOME/network/admin/listener.ora

echo "$ORACLE_SID=localhost:1521/$ORACLE_SID" >> $ORACLE_HOME/network/admin/tnsnames.ora
echo "$ORACLE_PDB= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = $ORACLE_PDB)
  )
)" >> $ORACLE_HOME/network/admin/tnsnames.ora

# Start the listener and configure the database.
lsnrctl start
gosu oracle /bin/bash -c "dbca -silent -responseFile $ASSETS_DIR/$DBCA_RSP"
