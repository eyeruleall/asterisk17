FROM ubuntu:latest

ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt upgrade && apt install -y -qq g++ make wget patch libedit-dev uuid-dev libjansson-dev libxml2-dev sqlite3 libsqlite3-dev libssl-dev
WORKDIR /usr/src
RUN wget https://downloads.asterisk.org/pub/telephony/asterisk/asterisk-17-current.tar.gz
RUN tar xvzf asterisk-17-current.tar.gz && rm asterisk-17-current.tar.gz
WORKDIR asterisk-17.2.0
RUN ./configure
RUN make menuselect.makeopts
RUN menuselect/menuselect --disable BUILD_NATIVE --enable CORE-SOUNDS-EN-ALAW menuselect.makeopts
RUN make && make install && make samples && ldconfig && \
  ### Backup original conf files
  for f in /etc/asterisk/*.conf; do cp -- "$f" "${f%.conf}.sample"; done && \
  mkdir /etc/asterisk/samples && mv /etc/asterisk/*.sample /etc/asterisk/samples/ && \
  ### Make conf files prettier
  for f in /etc/asterisk/*.conf; do sed -i '/^$/d' $f; sed -i '/^\s*;/d' $f; done && \
  ### Clean up files
  apt-get -y autoremove && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/* /usr/src/*

EXPOSE 5060 5061

VOLUME /etc/asterisk /var/lib/asterisk /var/spool/asterisk

CMD ["asterisk", "-f"]
