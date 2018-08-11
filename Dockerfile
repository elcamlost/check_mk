FROM debian:stretch

ENV CMK_SITE="cmk"
ENV MAILHUB="undefined"
ENV CMK_VERSION="1.5.0p1"
ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update && apt-get -y install curl 

EXPOSE 5000/tcp

#VOLUME /opt/omd

# retrieve and install the check mk binaries
RUN \
    apt-get -y update && apt-get -y install curl && \
    $(curl --remote-name https://mathias-kettner.de/support/${CMK_VERSION}/check-mk-raw-${CMK_VERSION}_0.stretch_amd64.deb && \
      dpkg -i check-mk-raw-${CMK_VERSION}_0.stretch_amd64.deb) || \
    apt-get install -y -f && \
    apt-get install -y ssmtp openssh-client && \
    rm -rf check-mk-raw-${CMK_VERSION}_0.stretch_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

# Creation of the site fails on creating tempfs, ignore it.
# Now turn tempfs off after creating the site
RUN omd create ${CMK_SITE} || \
    omd config ${CMK_SITE} set DEFAULT_GUI check_mk && \
    omd config ${CMK_SITE} set TMPFS off && \
    omd config ${CMK_SITE} set CRONTAB off && \
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0 && \
    omd config ${CMK_SITE} set APACHE_TCP_PORT 5000 && \
    ln -s "/omd/sites/${CMK_SITE}/var/log/nagios.log" /var/log/nagios.log

# In modern Debian systems only users inside mail group can use ssmtp. See https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=557948
RUN usermod -a -G mail ${CMK_SITE}

WORKDIR /omd
ADD bootstrap.sh /opt/
CMD ["/opt/bootstrap.sh"]
