# image for building Play 2.3 based app
FROM openjdk:8-slim
RUN apt-get update
RUN apt-get install -y wget unzip scala

# avoid AWTError for org.GNOME.Accessibility.AtkWrapper
RUN sed -i 's/^assistive_technologies=/#&/' /etc/java-8-openjdk/accessibility.properties

ENV VER=1.3.12
ENV ACTIVATOR=activator-$VER-minimal

WORKDIR /opt
RUN wget -q http://downloads.typesafe.com/typesafe-activator/$VER/typesafe-$ACTIVATOR.zip
RUN unzip typesafe-$ACTIVATOR.zip && rm typesafe-$ACTIVATOR.zip && mv $ACTIVATOR activator

ENV PATH="${PATH}:/opt/activator:/opt/activator/bin"
RUN bash -c "source ~/.bashrc"
RUN chmod a+x /opt/activator/bin/activator

# run activator firs time and cache its dependencies
RUN cd /tmp && activator new init minimal-scala && rmdir --ignore-fail-on-non-empty /tmp/init
