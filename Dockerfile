FROM alpine:latest
LABEL version="5.4.1" maintainer="Dynatrace ACE team<ace@dynatrace.com>"

RUN apk add --update --no-cache \
    curl \
    ca-certificates \
    bash \
    openssl-dev \
    nss \
    openjdk8-jre \
    unzip \
    tar


ARG JMETER_VERSION="5.4.1"

ENV JMETER_HOME /opt/jmeter/apache-jmeter-${JMETER_VERSION}
ENV	JMETER_BIN	${JMETER_HOME}/bin
ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz


# Installing Jmeter
RUN rm -rf /var/cache/apk/* \
    && mkdir -p /tmp/dependencies \
    && curl -L --silent ${JMETER_DOWNLOAD_URL} >  /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz  \
    && mkdir -p $JMETER_HOME \
    && tar -xzf /tmp/dependencies/apache-jmeter-${JMETER_VERSION}.tgz -C /opt/jmeter/apache-jmeter-${JMETER_VERSION} --strip-components 1\
    && rm -rf /tmp/dependencies

RUN echo 'export PATH=$PATH:$JMETER_BIN' >> /etc/profile

ENV JMETER_CMD_PLUGIN_DOWNLOAD_URL=https://jmeter-plugins.org/files/packages/jpgc-cmd-2.2.zip

RUN mkdir -p /tmp/dependencies \
    && curl -L --silent ${JMETER_CMD_PLUGIN_DOWNLOAD_URL} >  /tmp/dependencies/jpgc-cmd.zip  \
    && unzip  /tmp/dependencies/jpgc-cmd.zip -d /opt/jmeter/apache-jmeter-${JMETER_VERSION}\
    && rm -rf /tmp/dependencies

ENV JMETER_PERFMON_PLUGIN_DOWNLOAD_URL=https://jmeter-plugins.org/files/packages/jpgc-perfmon-2.1.zip

RUN mkdir -p /tmp/dependencies \
    && curl -L --silent ${JMETER_PERFMON_PLUGIN_DOWNLOAD_URL} >  /tmp/dependencies/jpgc-perfmon.zip  \
    && unzip  /tmp/dependencies/jpgc-perfmon.zip -d /opt/jmeter/apache-jmeter-${JMETER_VERSION}\
    && rm -rf /tmp/dependencies

ENV JMETER_SSH_PLUGIN_DOWNLOAD_URL=https://jmeter-plugins.org/files/packages/ssh-sampler-1.2.0.zip

RUN mkdir -p /tmp/dependencies \
    && curl -L --silent ${JMETER_SSH_PLUGIN_DOWNLOAD_URL} >  /tmp/dependencies/jpgc-ssh.zip  \
    && unzip  /tmp/dependencies/jpgc-ssh.zip -d /opt/jmeter/apache-jmeter-${JMETER_VERSION}\
    && rm -rf /tmp/dependencies

CMD ["/bin/bash", "-l", "-c"]
ENTRYPOINT ["/bin/bash", "-l", "-c"]