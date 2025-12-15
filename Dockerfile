#Download base image ubuntu 20.04
FROM ubuntu:24.04 AS base_os

# add vriviere's pre-built Ubuntu packages for cross-mint-essentials for x86_64 and aarch64
WORKDIR /tmp
FROM base_os AS add_prebuild_packages
RUN \
  apt -y update && \
  DEBIAN_FRONTEND=noninteractive apt -y install git clang \
  rsync curl build-essential python3 python-is-python3 upx-ucl && \
  echo "deb http://ppa.launchpad.net/vriviere/ppa/ubuntu focal main" \
  >  /etc/apt/sources.list.d/vriviere-ubuntu-ppa-focal.list && \
  echo "deb https://ppa.launchpadcontent.net/vriviere/arm/ubuntu focal main" \
  >> /etc/apt/sources.list.d/vriviere-ubuntu-ppa-focal.list && \
  apt-key adv --keyserver keyserver.ubuntu.com --recv-keys B5690522

# ---- Direct installation vasm ----
WORKDIR /tmp
FROM add_prebuild_packages AS vasm
RUN \
  curl http://sun.hasenbraten.de/vasm/release/vasm.tar.gz --output vasm.tar.gz && \
  gunzip vasm.tar.gz && \
  tar -xf vasm.tar && \
  cd vasm && \
  make CPU=m68k SYNTAX=mot && \
  cp vasmm68k_mot /usr/local/bin && \
  ln -s /usr/local/bin/vasmm68k_mot /usr/local/bin/vasm && \
  cp vobjdump /usr/local/bin && \
  cd .. && \
  rm -fR vasm*

# ---- Direct installation vlink ----
WORKDIR /tmp
FROM vasm AS vlink
RUN \
  curl http://sun.hasenbraten.de/vlink/release/vlink.tar.gz --output vlink.tar.gz && \
  gunzip vlink.tar.gz && \
  tar -xf vlink.tar && \
  cd vlink && \
  make && \
  cp vlink /usr/local/bin && \
  cd .. && \
  rm -fR vlink*

# ---- Download helper lib libcmini ----
WORKDIR /freemint
FROM vlink AS libcmini
RUN \
  mkdir -p /freemint/libcmini && \
  curl -L https://github.com/freemint/libcmini/releases/download/v0.54/libcmini-0.54.tar.gz --output libcmini.tar.gz && \
  gunzip libcmini.tar.gz && \
  tar -xf libcmini.tar -C libcmini && \
  rm -fR libcmini.tar

# ---- Dependencies ----
FROM libcmini AS dependencies
# vriviere's pre-built Ubuntu packages for cross-mint-essentials for x86_64 and aarch64
RUN \
  set DEBIAN_FRONTEND=noninteractive && \
  apt -y update && \
  apt -y install software-properties-common && \
  add-apt-repository ppa:vriviere/ppa && \
  apt -y update && \
  apt -y install cross-mint-essential cflib-m68k-atari-mint gemma-m68k-atari-mint ldg-m68k-atari-mint sdl-m68k-atari-mint ncurses-m68k-atari-mint zlib-m68k-atari-mint readline-m68k-atari-mint openssl-m68k-atari-mint

# ---- Build AGT tools ----
# logronoide has prebuild binaries in his git. Just use them
FROM dependencies AS agt
WORKDIR /
RUN \
  git clone https://bitbucket.org/logronoide/agtools.git && \
  chmod -R +x /agtools/bin/Linux


COPY ./agt/config.sh /agtools/config.sh

# Delete folders not needed at runtime and with dubious license files
RUN rm -fR /agtools/examples
RUN rm -fR /agtools/demos
RUN rm -fR /agtools/tutorials
RUN rm -fR /agtools/bin/Darwin
RUN rm -fR /agtools/bin/win
RUN rm -fR /agtools/tools

# ---- Configure entrypoint ----
WORKDIR /root
FROM agt AS entrypoint

COPY ./entrypoint.sh /

# Set environment variables.
ENV HOME=/root
ENV AGTROOT=/agtools

# Define working directory.

RUN ["chmod", "+x", "/entrypoint.sh"]

ENTRYPOINT ["/entrypoint.sh"]
