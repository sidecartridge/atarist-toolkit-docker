#Download base image ubuntu 20.04
FROM ubuntu:20.04 AS base_os

# ---- Direct installation vasm ----
WORKDIR /tmp
FROM base_os AS vasm
RUN apt -y update
RUN DEBIAN_FRONTEND=noninteractive apt -y install curl build-essential
RUN echo "deb http://ppa.launchpad.net/vriviere/ppa/ubuntu focal main" > /etc/apt/sources.list.d/vriviere-ubuntu-ppa-focal.list
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B5690522
RUN curl http://sun.hasenbraten.de/vasm/release/vasm.tar.gz --output vasm.tar.gz
RUN gunzip vasm.tar.gz
RUN tar -xf vasm.tar
WORKDIR /tmp/vasm
RUN make CPU=m68k SYNTAX=mot
RUN cp vasmm68k_mot /usr/local/bin
RUN ln -s /usr/local/bin/vasmm68k_mot /usr/local/bin/vasm
RUN cp vobjdump /usr/local/bin
WORKDIR /tmp
RUN rm -fR vasm*

# ---- Direct installation vlink ----
WORKDIR /tmp
FROM vasm AS vlink
RUN curl http://sun.hasenbraten.de/vlink/release/vlink.tar.gz --output vlink.tar.gz
RUN gunzip vlink.tar.gz
RUN tar -xf vlink.tar
WORKDIR /tmp/vlink
RUN make
RUN cp vlink /usr/local/bin
WORKDIR /tmp
RUN rm -fR vlink*

# ---- Download helper lib libcmini ----
RUN mkdir -p /freemint/libcmini
WORKDIR /freemint
FROM vlink AS libcmini
RUN curl -L https://github.com/freemint/libcmini/releases/download/v0.54/libcmini-0.54.tar.gz --output libcmini.tar.gz
RUN gunzip libcmini.tar.gz
RUN tar -xf libcmini.tar -C libcmini
RUN rm -fR libcmini.tar

RUN apt -y purge curl build-essential
RUN apt-get -y clean
RUN apt-get -y autoremove --purge


# ---- Dependencies ----
FROM libcmini AS dependencies
RUN apt -y update
RUN apt-get -y autoremove --purge
RUN DEBIAN_FRONTEND=noninteractive apt -y install cross-mint-essential
RUN apt-get -y clean
RUN apt-get -y autoremove --purge

# ---- Configure entrypoint ----
FROM dependencies AS entrypoint

WORKDIR /root

COPY ./entrypoint.sh /

# Set environment variables.
ENV HOME /root

# Define working directory.

RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]