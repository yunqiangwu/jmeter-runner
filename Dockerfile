FROM alpine:latest
LABEL version="5.4.1" maintainer="Dynatrace ACE team<ace@dynatrace.com>"

ARG JMETER_VERSION="5.4.1"

ENV JMETER_HOME /opt/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

RUN apk add --update --no-cache \
    curl \
    ca-certificates \
    bash \
    openssl-dev \
    nss \
    openjdk8-jre \
    unzip \
    tar

# Installing Jmeter
RUN rm -rf /var/cache/apk/* \
    && mkdir -p /tmp/dependencies \
    && curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
    && mkdir -p /opt/jmeter \
    && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt/jmeter --strip-components 1\
    && rm -rf /tmp/dependencies

ENV PATH $PATH:$JMETER_BIN

CMD ["/bin/bash", "-l", "-c"]
ENTRYPOINT ["/bin/bash", "-l", "-c"]