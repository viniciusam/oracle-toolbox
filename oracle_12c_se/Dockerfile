# https://docs.oracle.com/database/121/LADBI/app_nonint.htm#LADBI7831

FROM oraclelinux:7-slim

ENV ORACLE_BASE=/opt/oracle

ENV INSTALL_DIR=/oracle_install \
    SCRIPTS_DIR=/oracle_scripts \
    INSTALL_RSP=db_install.rsp \
    DBCA_RSP=dbca.rsp \
    NETCA_RSP=netca.rsp \
    ORACLE_HOME=$ORACLE_BASE/product/12102/dbhome_1 \
    ORACLE_INVENTORY=/home/oracle/oraInventory \
    GDBNAME=orcl12c \
    ORACLE_SID=orcl \
    ORACLE_PWD=oracle \
    ORACLE_HOME_LISTNER=$ORACLE_HOME

COPY install.sh $INSTALL_RSP $DBCA_RSP $NETCA_RSP $SCRIPTS_DIR/

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    echo "Installing oracle-rdbms-server-12cR1-preinstall..." && \
    yum install -y -q oracle-rdbms-server-12cR1-preinstall && \
    yum clean all

VOLUME ["$INSTALL_DIR"]
VOLUME ["$SCRIPTS_DIR"]
VOLUME ["$ORACLE_BASE/oradata"]
EXPOSE 1521 5500

CMD $SCRIPTS_DIR/install.sh
