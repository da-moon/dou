FROM quantumobject/docker-nagios

RUN apt-get update && apt-get -y install emacs net-tools

COPY ./dbhost.cfg /usr/local/nagios/etc/objects

RUN mkdir -p /tools
COPY ./check_nrpe.sh /tools

RUN echo cfg_file=/usr/local/nagios/etc/objects/dbhost.cfg >>/usr/local/nagios/etc/nagios.cfg


