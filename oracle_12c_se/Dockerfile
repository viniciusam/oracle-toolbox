# https://docs.oracle.com/database/121/LADBI/app_nonint.htm#LADBI7831

FROM oraclelinux:7-slim

ENV ORACLE_PDB=orcl12c \
    ORACLE_SID=orcl \
    ORACLE_PWD=oracle

COPY ./entrypoint.sh /
COPY ./assets /assets

RUN curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.10/gosu-amd64" && \
    chmod +x /usr/local/bin/gosu && \
    yum install -y oracle-rdbms-server-12cR1-preinstall && \
    yum clean all && \
    chmod +x /entrypoint.sh
    
VOLUME ["/install"]
EXPOSE 1521 5500

CMD /entrypoint.sh
