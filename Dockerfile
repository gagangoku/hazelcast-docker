# Docker file for running hazelcast

FROM openjdk:8-jre

MAINTAINER Gagandeep Singh <gagan.goku@gmail.com>

EXPOSE 5701


ENV HZ_VERSION 3.8.3
ENV HZ_HOME /opt/hazelcast/
RUN mkdir -p $HZ_HOME
WORKDIR $HZ_HOME

# Download hazelcast jars from maven repo.
ADD https://repo1.maven.org/maven2/com/hazelcast/hazelcast-all/$HZ_VERSION/hazelcast-all-$HZ_VERSION.jar $HZ_HOME

# Add your custom hazelcast.xml
ADD hazelcast.xml $HZ_HOME

# Run hazelcast
COPY run.sh $HZ_HOME

WORKDIR $HZ_HOME
CMD ["/bin/bash", "run.sh"]
