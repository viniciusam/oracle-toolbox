# https://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#XEINL122
# https://www.elastichosts.com/blog/oracle-database-installation-on-a-container-running-centos/

#FROM oraclelinux:5
FROM oraclelinux:7-slim

ENV INSTALL_DIR=/oracle_install \
    SCRIPTS_DIR=/oracle_scripts \
    INSTALL_RSP=xe.rsp

COPY install.sh $INSTALL_RSP $SCRIPTS_DIR/

RUN yum install -y glibc make binutils gcc libaio && \
    yum clean all && \
    chmod +r $SCRIPTS_DIR

VOLUME ["$INSTALL_DIR"]
EXPOSE 1521 8080

CMD $SCRIPTS_DIR/install.sh
