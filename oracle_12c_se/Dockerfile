# https://docs.oracle.com/database/121/LADBI/app_nonint.htm#LADBI7831

FROM oraclelinux:7-slim

ENV BASE_DIR=/u01 \
    SCRIPTS_DIR=/scripts

ENV ORACLE_BASE=$BASE_DIR/oracle \
    INSTALL_DIR=$BASE_DIR/install \
    INSTALL_RSP=db_install.rsp \
    DBCA_RSP=dbca.rsp \
    NETCA_RSP=netca.rsp \
    GDBNAME=orcl12c \
    ORACLE_SID=orcl \
    ORACLE_PWD=oracle

ENV ORACLE_HOME=$ORACLE_BASE/product/12102/dbhome_1 \
    ORACLE_HOME_LISTNER=$ORACLE_HOME \
    ORACLE_INVENTORY=$BASE_DIR/oraInventory

COPY install.sh $INSTALL_RSP $DBCA_RSP $NETCA_RSP $SCRIPTS_DIR/

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    yum install -y oracle-rdbms-server-12cR1-preinstall && \
    yum clean all

VOLUME ["$BASE_DIR"]
VOLUME ["$SCRIPTS_DIR"]
EXPOSE 1521 5500

CMD $SCRIPTS_DIR/install.sh
