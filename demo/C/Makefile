IDIR = include
CC = ../../st gcc
CFLAGS = -I$(IDIR)

ODIR = obj
SDIR = src
LDIR = lib

GEMLIBS=-lgem

_DEPS = 
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJS = hello_bb.tos hello_ge.prg

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

$(ODIR)/%_bb.tos: $(SDIR)/%_bb.c $(DEPS)
	$(CC) $^ -o $@ $(CFLAGS)

$(ODIR)/%_ge.prg: $(SDIR)/%_ge.c $(DEPS)
	$(CC) $^ -o $@ $(CFLAGS) $(GEMLIBS)

.PHONY: all
all: clean $(OBJS)
	
.PHONY: clean
clean:
	rm -f $(ODIR)/* *~ core $(INCDIR)/*~ 
