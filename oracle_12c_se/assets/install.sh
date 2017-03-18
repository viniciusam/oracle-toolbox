#!/bin/bash
set -e

cp $ASSETS_DIR/tmpl_db_install.rsp $ASSETS_DIR/db_install.rsp
INSTALL_RSP=$ASSETS_DIR/db_install.rsp

sed -i -e "s|###ORACLE_INVENTORY###|$ORACLE_INVENTORY|g" $INSTALL_RSP
sed -i -e "s|###ORACLE_BASE###|$ORACLE_BASE|g" $INSTALL_RSP
sed -i -e "s|###ORACLE_HOME###|$ORACLE_HOME|g" $INSTALL_RSP

chown -R oracle:oinstall $ORACLE_BASE
chmod -R 775 $ORACLE_BASE

gosu oracle bash -c "cd $INSTALL_DIR/database && ./runInstaller -silent -force -waitforcompletion -ignoreSysPrereqs -ignorePrereq -showProgress -responseFile $INSTALL_RSP"
$ORACLE_INVENTORY/orainstRoot.sh
$ORACLE_HOME/root.sh

rm -f $INSTALL_RSP
