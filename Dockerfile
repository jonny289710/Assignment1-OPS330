FROM ubuntu:26.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && \
    apt-get install -y bind9 bind9-utils dnsutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY named.conf /etc/bind/named.conf
COPY named.conf.options /etc/bind/named.conf.options
COPY named.conf.local /etc/bind/named.conf.local
COPY named.conf.root-hints /etc/bind/named.conf.root-hints

RUN mkdir -p /var/cache/bind && \
    chown -R bind:bind /var/cache/bind

EXPOSE 53/udp
EXPOSE 53/tcp

CMD ["named", "-g", "-u", "bind"]
