# https://docs.oracle.com/database/121/LADBI/app_nonint.htm#LADBI7831

FROM oraclelinux:7-slim

ENV ORACLE_BASE=/u01/oracle \
    ORACLE_INVENTORY=/u01/oracle/oraInventory

ENV INSTALL_DIR=/install \
    ASSETS_DIR=/assets \
    INSTALL_FILE_1=linuxamd64_12102_database_se2_1of2.zip \
    INSTALL_FILE_2=linuxamd64_12102_database_se2_2of2.zip \
    ORACLE_HOME=$ORACLE_BASE/product/12.1.0.2/dbhome_1 \
    ORACLE_HOME_LISTNER=$ORACLE_HOME \
    ORACLE_SID=orcl \
    ORACLE_PWD=oracle

ENV PATH=/usr/sbin:$PATH \
    PATH=$ORACLE_HOME/bin:$PATH \
    LD_LIBRARY_PATH=$ORACLE_HOME/lib:/lib:/usr/lib \
    CLASSPATH=$ORACLE_HOME/jlib:$ORACLE_HOME/rdbms/jlib

COPY $INSTALL_FILE_1 $INSTALL_FILE_2 $INSTALL_DIR/
COPY entrypoint.sh $ORACLE_BASE/
COPY assets/* $ASSETS_DIR/

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    yum install -y -q oracle-rdbms-server-12cR1-preinstall && \
    yum clean all && \
    chmod -R 777 $INSTALL_DIR && \
    chmod -R 777 $ASSETS_DIR

WORKDIR $INSTALL_DIR
RUN unzip -q $INSTALL_FILE_1 && \
    rm -f $INSTALL_FILE_1 && \
    unzip -q $INSTALL_FILE_2 && \
    rm -f $INSTALL_FILE_2 && \
    $ASSETS_DIR/install.sh && \
    $ASSETS_DIR/create_db.sh && \
    rm -rf $INSTALL_DIR
    
EXPOSE 1521
USER oracle
CMD $ORACLE_BASE/entrypoint.sh
