# Atari ST development toolkit docker image
A Docker image with the tools to develop Atari ST software in a modern environment.

[![Test](https://github.com/diegoparrilla/atarist-toolkit-docker/workflows/Test/badge.svg)](https://github.com/diegoparrilla/atarist-toolkit-docker/actions?query=workflow%3ATest) [![Deploy](https://github.com/diegoparrilla/atarist-toolkit-docker/workflows/Publish/badge.svg)](https://github.com/diegoparrilla/atarist-toolkit-docker/actions?query=workflow%3APublish)

## Introduction

Welcome to the Atari ST cross compiling docker image! This image has been created to provide modern developers with an easy and convenient way to write code for the Atari ST, a popular home computer released in the 1980s. 

It contains a range of cross compiling tools that allow you to write both assembler and C code for the Atari ST. With this image, you can easily set up a development environment on any modern machine, eliminating the need to track down and configure the tools yourself. 

Whether you're an experienced Atari ST developer or new to the platform, this image has everything you need to get started writing code for this classic computer.

## Tools available

- [`vasmm68k_mot`](http://sun.hasenbraten.de/vasm/) is an assembler for the Motorola 68000 microprocessor following the Motorola guidelines. It is customization of `vasm`, a portable multi-CPU and retargetable assembler to create linkable objects in various formats or absolute code. It can be used to convert assembly code into machine code that can be run on the Atari ST.

- [`vlink`](http://sun.hasenbraten.de/vlink/) is a portable linker, written in ANSI-C, that can read and write a wide range of object- and executable file formats. It can be used to link a specific target format from several different input file formats, or for converting, stripping and manipulating files. It takes object files produced by an assembler or compiler and combines them into a single executable file that can be run on the Atari ST.

- [`libcmini`](https://github.com/freemint/libcmini) is a minimal version of the C standard library. It provides functions that can be called from C code to perform common tasks such as input/output and memory allocation. libcmini aims to be a small-footprint C library for the m68k-atari-mint (cross) toolchain, similar to the C library Pure-C came with. Many GEM programs do not need full MiNT support and only a handful of C library functions. By default, gcc compiled programs on the Atari ST platform link to mintlib. Mintlib aims to implement all POSIX functionality to make porting Unix/Linux programs easier (which is a very good thing to have). For small GEM-based programs, this comes with a drawback, however: program size gets huge due to the underlying UNIX compatibility layer.

- [`m68k-atari-mint-gcc`]() is a cross compiler to generate C code usable in an Atari ST platform. It allows you to write C code on a modern machine and produce object files that can be run on the Atari ST. It is based on the GNU Compiler Collection (GCC) and has been specifically tailored for use with the Atari ST.

These tools are all included in the docker image and are ready to use out of the box, making it easy for you to get started writing code for the Atari ST. Hopefully, I will be expanding the range of tools and resources available to developers who use the image in the future. By adding more tools, a more comprehensive and complete development environment for developers who are interested in writing code for the Atari ST will come. 

## Prerequisites

In order to run a container image, a user will need to have the following:

- A host machine: This is the physical computer or virtual machine where the container will be run. The host machine must be running an operating system that supports the use of containers, such as Linux, MacOS or Windows.

- Container runtime: This is software that is responsible for running and managing containers on the host machine. Popular container runtimes include Docker and containerd. You can learn [how to install the Docker Desktop in its site](https://docs.docker.com/engine/install/).

- A command line interface (CLI): This is a tool that allows the user to interact with the host machine and container runtime using text-based commands. The CLI is typically used to manage and control containers, including pulling images, running containers, and viewing container logs. 

## How to install the docker image

The installation process will start executing the following script:

```
HERE
```

The script will perform two actions:

1. Download the latest version of the Atari ST development toolkit docker image the Docker Hub and install it in the available list of images in your Docker runtime.

2. Install the script `stcmd` in the PATH of your machine. To access the commands of the image the developer will only need to invoke the `stcmd`.

## How verify that the image is properly configured

Open a terminal in your Operating System, and enter the following command:

```
$ st
$WORKING_FOLDER is empty. It should have the absolute path to the source code.
```

The message means that the environment variable with the working folder of your project is missing. We will explain in the next chapter how to configure it.



