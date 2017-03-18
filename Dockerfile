FROM ubuntu:xenial

RUN apt-get update && \
    bash echo "Installing Dependencies..." && \
    apt-get install -qq curl git python && \
    # Docker Client
    VER="17.03.0-ce" && \
    curl -L -o /tmp/docker-$VER.tgz https://get.docker.com/builds/Linux/x86_64/docker-$VER.tgz && \
    tar -xz -C /tmp -f /tmp/docker-$VER.tgz && \
    mv /tmp/docker/* /usr/bin && \
    # Node & Dependencies
    curl -sL https://deb.nodesource.com/setup_6.x | bash - && \
    bash echo "Installing Node.js..." && \
    apt-get install -qq nodejs build-essential libfontconfig && \
    npm install -g phantomjs-prebuilt casperjs && \
    # Java
    bash echo "Installing Java..." && \
    apt-get install -qq software-properties-common && \
    add-apt-repository -qq ppa:webupd8team/java && apt-get update && \
    apt-get install -qq oracle-java8-installer && \
    apt-get install -qq oracle-java8-set-default && \
    # Clean
    apt-get clean
