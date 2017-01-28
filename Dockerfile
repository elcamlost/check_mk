FROM debian:latest

ENV CMK_VERSION="1.2.8p16"
ENV CMK_SITE="cmk"
ENV MAILHUB="undefined"

ARG DEBIAN_FRONTEND=noninteractive

RUN \
    apt-get update && apt-get -y install \
		time \
     	curl \
     	traceroute \
     	dialog \
     	dnsutils \
     	fping \
     	graphviz \
     	libapache2-mod-fcgid \
     	libapache2-mod-proxy-html \
     	libdbi1 \
     	python-openssl \
     	poppler-utils \
     	python-imaging \
     	python-reportlab \
     	libglib2.0-0 \
     	libgsf-1-114 \
     	libpcap0.8 \
     	libfreeradius-client2 \
     	python-ldap \
     	xinetd \
     	unzip \
     	snmp \
     	lcab \
     	rpcbind \
     	smbclient \
     	rsync \
     	php-pear \
     	php5-sqlite \
     	libevent-2.0-5 \
     	libgd3 \
     	libltdl7 \
     	libnet-snmp-perl \
     	libpango1.0-0 \
     	libperl5.20 \
     	libsnmp-perl \
     	libpython2.7 \
     	patch \
     	binutils \
     	rpm \
     	php5 \
     	php5-cgi \
     	php5-cli \
     	php5-gd \
     	php5-mcrypt \
     	libbind9-90 \
     	libdns100 \
     	libgssapi-krb5-2 \
     	libisc95 \
     	libisccfg90 \
     	libk5crypto3 \
     	libkrb5-3 \
     	liblwres90 \
     	libxml2 \
     	bind9-host \
     	libcurl3 \
     	libcdt5 \
     	libcgraph6 \
     	libexpat1 \
     	libgd3 \
     	libgvc6 \
     	libgvpr2 \
     	libx11-6 \
     	libxaw7 \
     	libxmu6 \
     	libxt6 \
     	fonts-liberation \
     	apache2-api-20120211 \
     	apache2 \
     	apache2-bin

ADD    bootstrap.sh /opt/
EXPOSE 5000/tcp

VOLUME /opt/omd

# retrieve and install the check mk binaries
RUN \
	curl --remote-name https://mathias-kettner.de/support/${CMK_VERSION}/check-mk-raw-${CMK_VERSION}_0.jessie_amd64.deb && \
	dpkg -i check-mk-raw-${CMK_VERSION}_0.jessie_amd64.deb


# Creation of the site fails on creating tempfs, ignore it.
# Now turn tempfs off after creating the site
RUN omd create ${CMK_SITE} || \
    omd config ${CMK_SITE} set DEFAULT_GUI check_mk && \
    omd config ${CMK_SITE} set TMPFS off && \
    omd config ${CMK_SITE} set CRONTAB off && \
    omd config ${CMK_SITE} set APACHE_TCP_ADDR 0.0.0.0 && \
    omd config ${CMK_SITE} set APACHE_TCP_PORT 5000 && \
    ln -s "/omd/sites/${CMK_SITE}/var/log/nagios.log" /var/log/nagios.log
    

WORKDIR /omd
ENTRYPOINT ["/opt/bootstrap.sh"]
