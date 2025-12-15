ODIR = ./obj
SOURCES_DIR = ./src
BUILD_DIR = ./build
DIST_DIR = ./dist
EXE = test.tos

# VASM PARAMETERS
VASMFLAGS=-Faout -quiet -x -m68000 -spaces -showopt
VASM = vasm
VLINK = vlink

# LIBCMINI PARAMETERS
# IMPORTANT! There is functional verson of the LIBCMINI library in the docker image
# To reference the library, it must set the absolute path inside the container image
# The library is stored in /freemint/libcmini 
# More info about the library: https://github.com/freemint/libcmini
LIBCMINI = /freemint/libcmini

# GCC PARAMETERS
CC = m68k-atari-mint-gcc
CFLAGS=-c -std=gnu99 -I$(LIBCMINI)/include -g

# LINKER PARAMETERS
LINKFLAGS=-nostdlib -s -L$(LIBCMINI)/lib -lcmini -lgcc -Wl,--traditional-format

_OBJS = hello.o

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

.PHONY: all
all: prepare dist

.PHONY: prepare
prepare: clean
	mkdir -p $(BUILD_DIR)

clean-compile : clean asm_functions.o screen.o main.o

asm_functions.o: prepare
	$(VASM) $(VASMFLAGS) $(SOURCES_DIR)/asm_functions.s -o $(BUILD_DIR)/asm_functions.o

fx_screen.o: prepare
	$(CC) $(CFLAGS) $(SOURCES_DIR)/fx_screen.c -o $(BUILD_DIR)/fx_screen.o

main.o: prepare
	$(CC) $(CFLAGS) $(SOURCES_DIR)/main.c -o $(BUILD_DIR)/main.o

main: main.o asm_functions.o fx_screen.o
	$(CC) $(LIBCMINI)/lib/crt0.o \
	      $(BUILD_DIR)/asm_functions.o \
		  $(BUILD_DIR)/fx_screen.o \
		  $(BUILD_DIR)/main.o \
		  -o $(BUILD_DIR)/test.tos $(LINKFLAGS);

.PHONY: dist
dist: main
	mkdir -p $(DIST_DIR)
	cp $(BUILD_DIR)/$(EXE) $(DIST_DIR) 	

.PHONY: clean
clean:
	rm -f $(ODIR)/* $(OUT)
	rm -rf $(BUILD_DIR)
	rm -rf $(DIST_DIR)