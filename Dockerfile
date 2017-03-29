FROM oraclelinux:7-slim

RUN curl --silent --location https://rpm.nodesource.com/setup_6.x | bash - && \
    yum -y install nodejs fontconfig && \
    yum -y groupinstall 'Development Tools' && \
    npm install -g phantomjs-prebuilt casperjs

COPY download.js download.sh /scripts/

VOLUME ["/downloads"]

WORKDIR /scripts
ENTRYPOINT ["bash", "/scripts/download.sh"]
CMD ["-h"]
