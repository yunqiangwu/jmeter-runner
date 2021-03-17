FROM alpine:latest
LABEL version="5.4.1" maintainer="Dynatrace ACE team<ace@dynatrace.com>"

ARG JMETER_VERSION="5.4.1"

ENV	JMETER_DOWNLOAD_URL  https://archive.apache.org/dist/jmeter/binaries/apache-jmeter-${JMETER_VERSION}.tgz

WORKDIR /jmeter

RUN apk add --update --no-cache \
    ca-certificates \
    openjdk8-jre

# Install JMeter
RUN wget -q ${JMETER_DOWNLOAD_URL} \
    && tar -xzf apache-jmeter-${JMETER_VERSION}.tgz \
    && mv apache-jmeter-${JMETER_VERSION}/* ./ \
    && rm -rf apache-jmeter-${JMETER_VERSION}.tgz apache-jmeter-${JMETER_VERSION}

ENTRYPOINT ["/bin/sh", "-c"]