FROM alpine:3.4
MAINTAINER Mojolicious

COPY * /
ENV TRAVELYNX_LISTEN=http://127.0.0.1:8093
ENV TRAVELYNX_IRIS_CACHE=/var/cache/dbf/iris
ENV TRAVELYNX_IRISRT_CACHE=/var/cache/dbf/iris-rt
ENV LANG=en_US.UTF-8

RUN apk update && \
  apk add perl perl-io-socket-ssl git perl-dbd-pg perl-dev g++ make wget curl ssmtp build-base postgresql-dev sudo db-dev && \
  curl -L https://cpanmin.us | perl - App::cpanminus && \
  sudo cpanm --installdeps --notest . -M https://cpan.metacpan.org && \
  apk del perl-dev g++ make wget curl && \
  rm -rf /root/.cpanm/* /usr/local/share/man/*

EXPOSE 8093

CMD bash -c "perl index.pl database migrate && hypnotoad -f index.pl"