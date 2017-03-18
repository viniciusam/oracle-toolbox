# https://docs.oracle.com/cd/E17781_01/install.112/e18802/toc.htm#XEINL122
# https://www.elastichosts.com/blog/oracle-database-installation-on-a-container-running-centos/

FROM oraclelinux:5

ENV ASSETS_DIR=/assets \
    ORACLE_SID=xe \
    ORACLE_PASSWORD=oracle

COPY assets $ASSETS_DIR
COPY entrypoint.sh /entrypoint.sh

#curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
#chmod +x /usr/local/bin/gosu && \

RUN bash echo "Installing Dependencies..." && \
    yum install -qq libaio bc initscripts net-tools glibc make binutils gcc && \
    yum clean all && \
    chmod -R 777 $ASSETS_DIR && \
    $ASSETS_DIR/install.sh

EXPOSE 1521
CMD /entrypoint.sh
