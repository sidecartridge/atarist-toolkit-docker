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

### Automated installation
The installation process will start executing the following script:

**For Linux**
```
curl -sL https://github.com/diegoparrilla/atarist-toolkit-docker/releases/download/latest/linux.sh | bash
```

**For MacOS**
```
curl -sL https://github.com/diegoparrilla/atarist-toolkit-docker/releases/download/latest/macos.sh | bash
```

**For Windows**
```
TO BE DONE
```

### Manual installation
The developer can download manually the installation scripts from:
- [linux.sh](https://github.com/diegoparrilla/atarist-toolkit-docker/releases/download/latest/linux.sh)
- [macos.sh](https://github.com/diegoparrilla/atarist-toolkit-docker/releases/download/latest/macos.sh)

Once the script is downloaded, the developer can execute it in the terminal of the Operating System.

**For Linux**
```
$ chmod +x linux.sh
$ ./linux.sh
```

**For MacOS**
```
$ chmod +x macos.sh
$ ./macos.sh
```

### What the installation script does

The script will perform two actions:

1. Download the latest version of the Atari ST development toolkit docker image the Docker Hub and install it in the available list of images in your Docker runtime.

2. Install the script `stcmd` in the PATH of your machine. To access the commands of the image the developer will only need to invoke the `stcmd`.

## How verify that the image is properly configured

Open a terminal in your Operating System, and enter the following command:

```
$ stcmd
$ST_WORKING_FOLDER is empty. It should have the absolute path to the source code.
```

If you see the message above, congratulations! You have successfully installed the Atari ST development toolkit docker image. The message means that the environment variable with the working folder of your project is missing. We will explain in the next chapter how to configure it.


## Start using the Atari ST development toolkit docker image

### Configure the working folder

The Atari ST development toolkit docker image needs to know where the source code of your project is located. To do this, you need to set the environment variable `$ST_WORKING_FOLDER` with the absolute path to the folder where your source code is located. 

The Docker image guarantees that all the needed libraries and dependencies are in one place and managed by the container. Sadly, the container has it's own file system, and the files that are created in the container are not accessible from the host machine. To solve this problem, the Atari ST development toolkit docker image will create a folder in the host machine and mount it in the container. This folder will be the working folder of your project and it's in the `ST_WORKING_FOLDER` environment variable.

Example: If you have a project in the folder `/home/user/my-st-megademo`, you need to set the environment variable `$ST_WORKING_FOLDER` with the value `/home/user/my-st-megademo`:

```
$ export ST_WORKING_FOLDER=/home/user/my-st-megademo
```

Now when you run the command `stcmd` you will see the following message:

```
$ stcmd

Available commands are:
- gcc: compiles C code into Atari ST TOS and GEM
- vasm: compiles M68K code into Atari ST TOS and GEM
- vlink: link object files into Atari ST executables

Don't forget to set up the ST_WORKING_FOLDER environment variable pointing to the
absolute path of your working folder.
```

### Set up a new C project

Let's create a project in the working folder `/home/user/my-st-megademo` that contains a simple C program that prints a message in the screen. To do this, we will use the command `stcmd gcc`:

Copy the following code into a file called `hello.c` in the working folder `/home/user/my-st-megademo`:

```hello.c
#include <stdio.h>

void main()
{
    printf("Hello World!\n");
    printf("Press Enter");
    getchar();
}
```

And now run the following command to compile the C code into an Atari ST executable:

```
stcmd gcc hello.c -o hello.tos
```

Now we have our first Atari ST executable in the working folder `/home/user/my-st-megademo`. To run it, we need to use an emulator or a real Atari ST machine. My testing platforms is [Hatari emulator](https://hatari.tuxfamily.org/), but there are more options.


### Set up a new M68K assembler project

Let's create a project in the working folder `/home/user/my-st-megademo-asm` that contains a simple M68K assembler program that prints a message in the screen. To do this, we will use the command `stcmd vasm`:

Copy the following code into a file called `hello.asm` in the working folder `/home/user/my-st-megademo-asm` (I have copied the code [from the awesome article and tutorials from François-Xavier Robin](https://www.fxjavadevblog.fr/m68k-atari-st-assembly-linux/)!):

```hello.s
; ---------------------------------------------------
; Hello, Bitmap Brothers! en assembleur pour Atari ST 
; (inspiré du HelloWorld de Vretrocomputing, 2019.)
; Date : 02/2021
; ---------------------------------------------------

; -- DEBUT ----------------------------------------------------------------------
; affichage du message
	PEA     MESSAGE	        ; 4 octets sur la pile (PEA = PUSH EFFECTIVE ADDRESS)
	MOVE.W	#9,-(sp)		; 2 octets sur la pile (9 = affiche chaine)s
	TRAP	#1
	ADDQ.L	#6,sp			; ajustement de la pile 6 octets

; attente d'une touche
	MOVE.W	#8,-(sp)		; 2 octets sur la pile (8 = attente clavier)
	TRAP	#1
	ADDQ.L	#2,sp			; ajustement de la pile de 2 octects

; fin du processus, retour au GEM
	CLR.W   -(sp)			; 1 octet sur la pile
	TRAP    #1				; pas de besoin d'ajuster
; -- FIN ------------------------------------------------------------------------

; -- EQUATES ------------------------------------
CR	EQU	$0D	; ASCII Carriage Return
LF	EQU	$0A	; ASCII Line Feed
ES	EQU	$00	; Fin de chaine 
EA	EQU	$82 ; E accent aigue selon la table ASCII
; -- EQUATES ------------------------------------

; -- DATA -----------------------------------------------
MESSAGE:
	DC.B	  "Hello Bitmap Brothers!",CR,LF
	DC.B	  "----------------------",CR,LF
	DC.B      "- Compil",EA," avec vasm sur Linux",CR,LF
	DC.B      "- Link",EA," avec vlink sur Linux",CR,LF
	DC.B	  "----------------------",CR,LF
	DC.B	  "<APPUYER SUR UNE TOUCHE>",CR,LF,ES
; -- DATA -----------------------------------------------
```

And now run the following command to compile the M68K code:

```
$ stcmd vasm hello.s -o hello.o -Felf
vasm 1.9a (c) in 2002-2022 Volker Barthelmann
vasm M68k/CPU32/ColdFire cpu backend 2.5f (c) 2002-2022 Frank Wille
vasm motorola syntax module 3.16 (c) 2002-2022 Frank Wille
vasm ELF output module 2.7a (c) 2002-2016,2020,2022 Frank Wille

CODE(acrx2):	         184 bytes
```

And now link the object file into an Atari ST executable:

```
$ stcmd vlink hello.o -bataritos -o hello.tos
```

### The demo folder

## The demo folder
In the demo folder of the github repository you can find some examples of Atari ST development with the Atari ST development toolkit docker image. To run the examples, you need to clone the repository first:

```
$ git clone git@github.com:diegoparrilla/atarist-toolkit-docker.git
```

Navigate to the different projects inside the `demo` folder and execute `make` to build. But, before you do that, you need to set the environment variable `$ST_WORKING_FOLDER` with the value of the absolute path of the demo folder:

```
$ export ST_WORKING_FOLDER=/home/user/atarist-toolkit-docker/demo/SUBPROJECT
$ make
```

## "The Silly Demo" 

*The Silly Demo* is a sample demo created with the Atari ST development toolkit docker image. You can learn more about it in the [The Silly Demo](https://github.com/diegoparrilla/atarist-silly-demo) repository.

## References

* [Atari ST development toolkit docker image](https://hub.docker.com/r/logronoide/atarist-toolkit-docker)
* [Atari ST development toolkit docker image source code](https://github.com:diegoparrilla/atarist-toolkit-docker)
* [Atari ST samples of cross development (French)](https://www.fxjavadevblog.fr/m68k-atari-st-assembly-linux/)
* [The Atari ST MC68000 Assembly Language Tutorials](https://nguillaumin.github.io/perihelion-m68k-tutorials/index.html)


## Contribute

Thank you for your interest in contributing to this repository! We welcome and appreciate contributions from the community. Here are a few ways you can contribute:

- Report bugs: If you find a bug in the code, please let us know by opening an issue. Be sure to include details about the error, how to reproduce it, and any possible workarounds.

- Suggest new features: Have an idea for a new feature or improvement? We'd love to hear about it. Open an issue to start a discussion.

- Contribute code: If you're a developer and want to contribute code to this project, here are a few steps to get started:
    * Fork the repository and clone it to your local machine.
    * Create a new branch for your changes.
    * Make your changes, including tests to cover your changes.
    * Run the tests to ensure everything is working.
    * Commit your changes and push them to your fork.
    * Open a pull request to this repository.


- Write documentation: If you're not a developer, you can still contribute by writing documentation, such as improved usage examples or tutorials.

- Share feedback: Even if you don't have any specific changes in mind, we welcome your feedback and thoughts on the project. You can share your feedback by opening an issue or by joining the repository's community.

We appreciate any and all contributions, and we'll do our best to review and respond to your submissions in a timely manner. Please note that all contributors are expected to follow our code of conduct (one day we will have one!). Thank you for your support!

## License
This project is licenses under the GNU General Public License v3.0. See the [LICENSE](LICENSE) file for details.
