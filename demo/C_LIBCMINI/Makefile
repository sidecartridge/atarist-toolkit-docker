CC= stcmd gcc
LIBCMINI=/freemint/libcmini/lib
CFLAGS=-std=gnu99 -I/freemint/libcmini/include -nostdlib $(LIBCMINI)/crt0.o 
LINKFLAGS=-s -L$(LIBCMINI) -lcmini -lgcc
all: clean main

main: 
	mkdir -p out
	$(CC) $(CFLAGS) src/main.c -o out/main.tos $(LINKFLAGS)

clean:
	rm -rf out/*.tos