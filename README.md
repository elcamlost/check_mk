# nlmacamp/check_mk:1.2.8p16


- [Introduction](#introduction)
  - [Contributing](#contributing)
  - [Issues](#issues)

- [Getting started](#getting-started)
  - [Installation](#installation)
  - [Quickstart](#quickstart)

# Introduction

`Dockerfile` to create a [Docker](https://www.docker.com/) container image for [Check_MK](https://mathias-kettner.de/check_mk.html).

Check_MK is comprehensive IT monitoring solution in the tradition of [Nagios](https://www.nagios.org/).

This docker images is based on the Check_MK [Raw Edition](http://mathias-kettner.com/check_mk_introduction.html) - a free and 100% open-source version.

The Check_MK Raw Edition is a full-blown IT monitoring solution.

## Contributing

If you find this image useful you can help. - Send a pull request with your awesome features and bug fixes


## Issues

Before reporting your issue please try updating Docker to the latest version and check if it resolves the issue. Refer to the Docker [installation guide](https://docs.docker.com/installation) for instructions.

SELinux users should try disabling SELinux using the command `setenforce 0` to see if it resolves the issue.

# Getting started

## Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/nlmacamp/check_mk) and is the recommended method of installation.

```bash
docker pull elcamlost/check_mk:1.2.8p16
```

Alternatively you can build the image yourself.

```bash
docker build -t elcamlost/debian-check_mk github.com/elcamlost/check_mk
```

## Quickstart

Start Check_MK using:

```bash
    docker run -itd --name check_mk \
           --publish 5000:5000 \
           --volume /opt/omd/sites/cmk/etc/check_mk:/opt/omd/sites/cmk/etc/check_mk
           --volume /opt/omd/sites/cmk/var/pnp4nagios/perfdata:/opt/omd/sites/cmk/var/pnp4nagios/perfdata
           --restart always \
           elcamlost/check_mk
```

*OPTIONAL:* Specify outgoing mail server with `-e "MAILHUB=<IP:PORT>"`

Check the status of check_mk using:

```bash
docker exec -it check_mk omd status
```

the result should look like:

```bash
Doing 'status' on site mva:
mkeventd:       running
rrdcached:      running
npcd:           running
nagios:         running
apache:         running
-----------------------
Overall state:  running
```


Fireup the Check_MK GUI:

Browse to http://localhost:5000/cmk

login with the default user omdadmin with password omd
