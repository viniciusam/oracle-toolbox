FROM oraclelinux:7-slim

COPY download.js download.sh /scripts/

RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum -y install nodejs fontconfig && \
    yum -y groupinstall 'Development Tools' && \
    npm install -g phantomjs-prebuilt casperjs && \
    chmod -R 777 /scripts

VOLUME ["/downloads"]

WORKDIR /scripts
ENTRYPOINT ["/scripts/download.sh"]
CMD ["-h"]
