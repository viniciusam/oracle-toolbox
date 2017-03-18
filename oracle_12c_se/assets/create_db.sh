#!/bin/bash
set -e

cp $ASSETS_DIR/tmpl_dbca.rsp $ASSETS_DIR/dbca.rsp
DBCA_RSP=$ASSETS_DIR/dbca.rsp

sed -i -e "s|###ORACLE_SID###|$ORACLE_SID|g" $DBCA_RSP
sed -i -e "s|###ORACLE_PWD###|$ORACLE_PWD|g" $DBCA_RSP

echo "NAME.DIRECTORY_PATH= {TNSNAMES, EZCONNECT, HOSTNAME}" > $ORACLE_HOME/network/admin/sqlnet.ora

echo "LISTENER = 
(DESCRIPTION_LIST = 
  (DESCRIPTION = 
    (ADDRESS = (PROTOCOL = IPC)(KEY = EXTPROC1)) 
    (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521)) 
  ) 
) 
" > $ORACLE_HOME/network/admin/listener.ora

#echo "$ORACLE_SID=localhost:1521/$ORACLE_SID" >> $ORACLE_HOME/network/admin/tnsnames.ora
echo "$ORACLE_SID= 
(DESCRIPTION = 
  (ADDRESS = (PROTOCOL = TCP)(HOST = 0.0.0.0)(PORT = 1521))
  (CONNECT_DATA =
    (SERVER = DEDICATED)
    (SERVICE_NAME = $ORACLE_SID)
  )
)" >> $ORACLE_HOME/network/admin/tnsnames.ora

# Configure the database.
gosu oracle bash -c "dbca -silent -responseFile $DBCA_RSP"

rm -f $DBCA_RSP
