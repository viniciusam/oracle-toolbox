# https://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#XEINL122
# https://www.elastichosts.com/blog/oracle-database-installation-on-a-container-running-centos/

FROM oraclelinux:5

ENV INSTALL_DIR=/install \
    SCRIPTS_DIR=/scripts \
    INSTALL_RSP=xe.rsp \
    ORACLE_SID=xe \
    ORACLE_PASSWORD=oracle

COPY install.sh $INSTALL_RSP $SCRIPTS_DIR/

#curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
#chmod +x /usr/local/bin/gosu && \

RUN yum install -y libaio bc initscripts net-tools glibc make binutils gcc && \
    yum clean all && \
    chmod +r $SCRIPTS_DIR

VOLUME ["$INSTALL_DIR"]
EXPOSE 1521 8080

CMD $SCRIPTS_DIR/install.sh
