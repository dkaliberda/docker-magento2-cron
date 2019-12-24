FROM dkaliberda/magento2-apache-php72
MAINTAINER Dmitrij Kaliberda <dkaliberda.ua@gmail.com>

ADD crontab /crontab.www-data
ADD start.sh /start.sh
ADD updatenodes.php /updatenodes.php

RUN apt-get update && apt-get install -y cron rsyslog \
  libvarnishapi2 \
  && apt download varnish \
  && dpkg --unpack varnish*.deb; \
  rm /var/lib/dpkg/info/varnish.postinst -f; \
  dpkg --configure varnish \
  && apt install -yf \
  && apt-get clean \
  && rm -rf varnish*.deb

RUN crontab -u www-data /crontab.www-data; \
  chmod +x /start.sh; \
  touch /var/log/syslog; \
  touch /var/log/cron.log; \
  rm /register-host-on-redis.sh; \
  rm /unregister-host-on-redis.sh

CMD "/start.sh"
