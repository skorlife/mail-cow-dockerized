FROM alpine:3.17
LABEL maintainer "Andre Peters <andre.peters@servercow.de>"

# renovate: datasource=github-tags depName=dovecot/core versioning=semver-coerced
ARG DOVECOT=2.3.20
# renovate: datasource=github-releases depName=tianon/gosu versioning=semver-coerced
ARG GOSU_VERSION=1.16
ENV LC_ALL C


# Add groups and users before installing Dovecot to not break compatibility
RUN addgroup -g 5000 vmail \
  && addgroup -g 401 dovecot \
  && addgroup -g 402 dovenull \
  && addgroup sogo \
  && adduser nobody sogo \
  && adduser -D -G vmail -u 5000 vmail -h /var/vmail \
  && adduser -s /bin/false -D -H -u 401 -G dovecot -h /dev/null dovecot -g "Dovecot unprivileged user" \
  && adduser -s /bin/false -D -H -u 402 -G dovenull -h /dev/null dovenull -g "Dovecot login user" \
  && apk update \
  && apk add \
  ca-certificates \
  bash \
  perl-app-cpanminus \
  curl \
  bind-tools \
  dirmngr \
  gettext \
  gpg \
  jq \
  lz4 \
  lz4-dev \
  perl-ntlm \
  perl-cgi \
  perl-crypt-openssl-rsa \
  perl-crypt-ssleay \
  perl-data-uniqid \
  perl-dbd-mysql \
  perl-dbi \
  perl-digest-hmac \
  perl-dist-checkconflicts \
  perl-encode-imaputf7 \
  perl-file-copy-recursive \
  perl-file-tail \
  perl-html-parser \
  #perl-io-socket-compress \
  perl-io-socket-inet6 \
  perl-io-socket-ssl \
  #libio-tee-perl \
  perl-ipc-run \
  perl-json-webtoken \
  #perl-lockfile-simple \
  perl-mail-imapclient \
  perl-module-implementation \
  perl-module-scandeps \
  perl-net-ssleay \
  perl-package-stash \
  perl-package-stash-xs \
  perl-par-packer \
  perl-parse-recdescent\
  #libproc-processtable-perl \
  #libreadonly-perl \
  perl-regexp-common \
  perl-sys-meminfo \
  perl-term-readkey \
  perl-test-deep \
  perl-test-fatal \
  perl-test-mock-guard \
  perl-test-mockobject \
  perl-test-nowarnings \
  perl-test-pod \
  perl-test-requires \
  perl-test-simple \
  perl-test-warn \
  perl-try-tiny \
  libunistring \
  perl-uri \
  perl-libwww \
  lua-sql-mysql \
  lua-socket \
  mariadb-client \
  procps \
  py3-pip \
  redis \
  supervisor \
  syslog-ng \
  # syslog-ng-core \
  syslog-ng-redis \
  syslog-ng-json \
  dpkg \
  wget \
  && dpkgArch="$(dpkg --print-architecture | awk -F- '{ print $NF }')" \
  && wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch" \
  && chmod +x /usr/local/bin/gosu \
  && gosu nobody true \
  && apk add \
  dovecot \
  dovecot-dev \
  dovecot-lua \
  # dovecot-managesieved \
  dovecot-pigeonhole-plugin \
  dovecot-lmtpd \
  dovecot-ldap \
  dovecot-mysql \
  dovecot-pop3d \
  dovecot-fts-solr \
  && pip3 install mysql-connector-python html2text jinja2 redis \
  && rm -rf /tmp/* /var/tmp/* /root/.cache/

COPY trim_logs.sh /usr/local/bin/trim_logs.sh
COPY clean_q_aged.sh /usr/local/bin/clean_q_aged.sh
COPY syslog-ng.conf /etc/syslog-ng/syslog-ng.conf
COPY syslog-ng-redis_slave.conf /etc/syslog-ng/syslog-ng-redis_slave.conf
COPY imapsync /usr/local/bin/imapsync
COPY imapsync_runner.pl /usr/local/bin/imapsync_runner.pl
COPY report-spam.sieve /usr/lib/dovecot/sieve/report-spam.sieve
COPY report-ham.sieve /usr/lib/dovecot/sieve/report-ham.sieve
COPY rspamd-pipe-ham /usr/lib/dovecot/sieve/rspamd-pipe-ham
COPY rspamd-pipe-spam /usr/lib/dovecot/sieve/rspamd-pipe-spam
COPY sa-rules.sh /usr/local/bin/sa-rules.sh
COPY maildir_gc.sh /usr/local/bin/maildir_gc.sh
COPY docker-entrypoint.sh /
COPY supervisord.conf /etc/supervisor/supervisord.conf
COPY stop-supervisor.sh /usr/local/sbin/stop-supervisor.sh
COPY quarantine_notify.py /usr/local/bin/quarantine_notify.py
COPY quota_notify.py /usr/local/bin/quota_notify.py
COPY repl_health.sh /usr/local/bin/repl_health.sh

ENTRYPOINT ["/docker-entrypoint.sh"]
CMD exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf