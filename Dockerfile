FROM virtualzone/nginx-php-mysql:latest
MAINTAINER Heiner Peuser <heiner.peuser@weweave.net>

RUN apt-get update && apt-get install -y \
    wget \
    pwgen

ADD custom.conf /etc/nginx/
ADD run.sh /root/

RUN apt-get clean
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

CMD ["bin/bash", "/root/run.sh"]
