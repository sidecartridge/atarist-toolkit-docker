#Download base image ubuntu 20.04
FROM ubuntu:20.04 AS base_os

# ---- Direct installation vasm ----
WORKDIR /tmp
FROM base_os AS vasm
RUN apt -y update
RUN DEBIAN_FRONTEND=noninteractive apt -y install git clang rsync curl build-essential python3 python-is-python3 upx-ucl
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

# ---- Dependencies ----
FROM libcmini AS dependencies
RUN apt -y update
RUN DEBIAN_FRONTEND=noninteractive apt -y install cross-mint-essential

# ---- Build AGT tools ----
FROM dependencies AS agt
WORKDIR /
RUN git clone https://bitbucket.org/logronoide/agtools.git
#RUN git clone https://bitbucket.org/d_m_l/agtools.git
RUN mkdir -p /agtools/bin/Linux/x86_64
WORKDIR /agtools/bin/Linux/x86_64

# Install rmac assembler
RUN curl http://rmac.is-slick.com/static/rmac-2.1.8-lin64.tar.gz --output rmac.tar.gz
RUN gunzip rmac.tar.gz
RUN tar -xf rmac.tar
RUN rm -fR rmac.tar
RUN mv rmac rmac.folder
RUN mv rmac.folder/rmac rmac
RUN chmod +x rmac
RUN rm -fR rmac.folder
RUN ls -al rmac

# Create 3rdparty/lzsa
WORKDIR /
RUN git clone https://github.com/emmanuel-marty/lzsa.git
WORKDIR /lzsa
RUN make
RUN cp /lzsa/lzsa /agtools/bin/Linux/x86_64/lzsa
RUN rm -fR /lzsa

# Hostinfo.txt is the platform we are building for
WORKDIR /agtools
RUN echo "Linux/Linux/x86_64" > hostinfo.txt

# The makedefs should point to the docker excutables
#COPY ./agt/makedefs.stcmdgcc /agtools/makedefs.stcmdgcc
#COPY ./agt/makerules.stcmdgcc /agtools/makerules.stcmdgcc
#COPY ./agt/makedefs /agtools/makedefs
COPY ./agt/config.sh /agtools/config.sh

# Create agtcut
WORKDIR /agtools/tools/agtcut
RUN make

# Create packwrap
WORKDIR /agtools/tools/packwrap
RUN make

# Create packwrap
WORKDIR /agtools/tools/pcs2agi
RUN make

# Create 3rdparty/zx0
WORKDIR /agtools/tools/3rdparty/zx0
RUN make

# Create 3rdparty/lz77
WORKDIR /agtools/tools/3rdparty/lz77
RUN make

# Delete folders not needed at runtime and with dubious license files
RUN rm -fR /agtools/examples
RUN rm -fR /agtools/demos
RUN rm -fR /agtools/tutorials
RUN rm -fR /agtools/bin/Darwin
RUN rm -fR /agtools/bin/win
RUN rm -fR /agtools/tools

# ---- Configure entrypoint ----
FROM agt AS entrypoint

WORKDIR /root

COPY ./entrypoint.sh /

# Set environment variables.
ENV HOME /root
ENV AGTROOT=/agtools

# Define working directory.

RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]