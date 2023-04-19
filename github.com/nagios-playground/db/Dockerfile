FROM postgres:latest

# nrpe
EXPOSE 5666

# nsca
EXPOSE 5667

RUN \
    apt-get update && apt-get -y install curl less emacs iptables net-tools

RUN \
    mkdir /nagios; \
    cd /nagios; \
    curl -O https://assets.nagios.com/downloads/nagiosxi/agents/linux-nrpe-agent.tar.gz; \
    tar xzf linux-nrpe-agent.tar.gz

ENV NAGIOS_HOST dockercomposeexample_nagios_run_1.dockercomposeexample_default

RUN \
    mv /bin/systemctl /bin/systemctl.bak; \
    sed -i s/read.*/ALLOW_INPUT=${NAGIOS_HOST}/ /nagios/linux-nrpe-agent/subcomponents/install; \
    sed -i '/.* read -p.*/D' /nagios/linux-nrpe-agent/4-firewall; \
    echo 'ALL: ALL' >>/etc/hosts.allow

RUN \
    cd /nagios/linux-nrpe-agent; \
    ./fullinstall --non-interactive
