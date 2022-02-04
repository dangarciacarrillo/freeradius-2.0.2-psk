FROM i386/ubuntu:12.04


WORKDIR /etc/apt
COPY src/sources.list . 

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y autoconf libtool libssl-dev libxml2-dev openssl
RUN apt-get install -y build-essential python python3 vim clang

WORKDIR /src
COPY src .
RUN ls -la

WORKDIR /src/hostapd/eap_example
RUN make CONFIG_SOLIB=yes

WORKDIR /src/
RUN tar xvf freeradius-server-2.0.2.tar.bz2
RUN mv /src/freeradius_mod_files/modules.c /src/freeradius-server-2.0.2/src/main/
RUN mv /src/freeradius_mod_files/Makefile /src/freeradius-server-2.0.2/src/modules/rlm_eap2/
WORKDIR /src/freeradius-server-2.0.2

RUN ls -la
RUN ./configure --prefix=/freeradius-psk --with-modules=rlm_eap2 
RUN make 
RUN make install


RUN cp /src/freeradius_mod_files/eap.conf /freeradius-psk/etc/raddb/
RUN cp /src/freeradius_mod_files/clients.conf /freeradius-psk/etc/raddb/
RUN cp /src/freeradius_mod_files/users /freeradius-psk/etc/raddb/
RUN cp /src/freeradius_mod_files/default /freeradius-psk/etc/raddb/sites-available/




ENV LD_PRELOAD /src/hostapd/eap_example/libeap.so
CMD ["/freeradius-psk/sbin/radiusd","-X"]


