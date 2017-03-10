#!/bin/bash
set -e

INSTALL_RSP=db_install.rsp

mkdir -p $ORACLE_BASE
mkdir -p $ORACLE_INVENTORY
chown -R oracle:oinstall $ORACLE_BASE
chown -R oracle:oinstall $ORACLE_INVENTORY
chmod -R 775 $ORACLE_BASE
chmod -R 775 $ORACLE_INVENTORY

sed -i -e "s|###ORACLE_INVENTORY###|$ORACLE_INVENTORY|g" $ASSETS_DIR/$INSTALL_RSP
sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" $ASSETS_DIR/$INSTALL_RSP
sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" $ASSETS_DIR/$INSTALL_RSP

gosu oracle /bin/bash -c "cd $INSTALL_DIR/database && ./runInstaller -silent -force -waitforcompletion -ignoreSysPrereqs -ignorePrereq -showProgress -responseFile $ASSETS_DIR/$INSTALL_RSP"
$ORACLE_INVENTORY/orainstRoot.sh
$ORACLE_HOME/root.sh
