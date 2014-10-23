FROM ubuntu:14.04
MAINTAINER "Jeff Bogatay <jeff@bogatay.com>"

ENV DEBIAN_FRONTEND noninteractive

VOLUME ["/config","/downloads"]
EXPOSE 6789
CMD ["/app/start.sh"]

RUN echo "APT::Install-Recommends 0;" >> /etc/apt/apt.conf.d/01norecommends &&\
    echo "APT::Install-Suggests 0;" >> /etc/apt/apt.conf.d/01norecommends &&\
    echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty universe multiverse" >> /etc/apt/sources.list   &&\
    echo "deb http://us.archive.ubuntu.com/ubuntu/ trusty-updates universe multiverse" >> /etc/apt/sources.list  &&\    
    apt-get update &&\
    apt-get install -qy nzbget unrar supervisor p7zip-full &&\
    apt-get clean &&\
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ADD app/ /app/
