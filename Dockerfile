FROM centos:7

MAINTAINER Christoph Wiechert <wio@psitrax.de>

ENV REFRESHED_AT="2017-01-26" \
    ICINGA2_VERSION="2.6.0" \
    TIMEZONE="UTC" \
    MYSQL_AUTOCONF=true \
    MYSQL_HOST=mysql \
    MYSQL_PORT=3306 \
    MYSQL_USER=root \
    MYSQL_PASS=root \
    MYSQL_DB=icinga2 \
    ICINGA_API_PASS="super-secret" \
    ICINGA_LOGLEVEL=warning \
    ICINGA_FEATURES="ido-mysql api"

RUN rpm --import http://packages.icinga.org/icinga.key \
    && curl -sSL http://packages.icinga.org/epel/ICINGA-release.repo > /etc/yum.repos.d/ICINGA-release.repo \
    && yum -y install epel-release deltarpm \
    && yum -y install \
      bash-completion bash-completion-extras \
      less \
      vim \
      wget \
      net-tools \
      openssl \
      ca-certificates \
      mariadb \
      nagios-plugins* \
      perl-Crypt-Rijndael bc \
      swaks \
      sendxmpp \
    && sed -i 's~nodocs~~g' /etc/yum.conf \
    && yum -y install \
      icinga2-$ICINGA2_VERSION \
      icinga2-ido-mysql \
    && wget -O /usr/share/vim/vimfiles/ftdetect/icinga2.vim https://raw.githubusercontent.com/Icinga/icinga2/master/tools/syntax/vim/ftdetect/icinga2.vim \
    && wget -O /usr/share/vim/vimfiles/syntax/icinga2.vim https://raw.githubusercontent.com/Icinga/icinga2/master/tools/syntax/vim/syntax/icinga2.vim \
    && chsh -s /bin/bash icinga \
    && su icinga -c 'cp /etc/skel/.bash* /var/spool/icinga2' \
    && chmod u+s /usr/bin/ping \
    && yum clean all && rm -rf /var/yum/cache \
    && localedef -f UTF-8 -i en_US en_US.UTF-8

ADD rootfs /

EXPOSE 5665
VOLUME ["/icinga2"]

# Is this sufficient?
# TODO: what if API feature is not enabled?
HEALTHCHECK CMD netstat -an | grep 5665 | grep -iq listen

CMD ["/init/run.sh"]