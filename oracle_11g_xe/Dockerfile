# https://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#XEINL122
# https://www.elastichosts.com/blog/oracle-database-installation-on-a-container-running-centos/

FROM oraclelinux:7-slim

ENV ASSETS_DIR=/assets \
    INSTALL_DIR=/install \
    INSTALL_FILE=oracle-xe-11.2.0-1.0.x86_64.rpm.zip \
    ORACLE_SID=xe \
    ORACLE_PASSWORD=oracle

COPY $INSTALL_FILE $INSTALL_DIR/
COPY assets/* $ASSETS_DIR/
COPY entrypoint.sh /entrypoint.sh

#curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
#chmod +x /usr/local/bin/gosu && \

RUN yum install -y -q unzip libaio bc initscripts net-tools glibc make binutils gcc && \
    yum clean all && \
    chmod -R 777 $ASSETS_DIR && \
    chmod -R 777 $INSTALL_DIR

WORKDIR $INSTALL_DIR
RUN unzip -q $INSTALL_FILE && \
    rm -f $INSTALL_FILE && \
    $ASSETS_DIR/install.sh && \
    rm -rf $INSTALL_DIR

EXPOSE 1521
CMD /entrypoint.sh
