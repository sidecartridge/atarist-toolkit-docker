IDIR = include
CC = m68k-atari-mint-gcc
CFLAGS = -I$(IDIR)

# Use traditional header and reserve 32KB stack to fix 3-bomb crash when run from HDD
TOSLDFLAGS = -Wl,--traditional-format,--stack=32768

ODIR = obj
SDIR = src
LDIR = lib

GEMLIBS=-lgem

_DEPS = 
DEPS = $(patsubst %,$(IDIR)/%,$(_DEPS))

_OBJS = hello_bb.tos hello_ge.prg

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

$(ODIR)/%_bb.tos: $(SDIR)/%_bb.c $(DEPS)
	@mkdir -p $(@D)
	$(CC) $^ -o $@ $(CFLAGS) $(TOSLDFLAGS)

$(ODIR)/%_ge.prg: $(SDIR)/%_ge.c $(DEPS)
	@mkdir -p $(@D)
	$(CC) $^ -o $@ $(CFLAGS) $(GEMLIBS)

.PHONY: all
all: clean $(OBJS)
	
.PHONY: clean
clean:
	rm -f $(ODIR)/* *~ core $(INCDIR)/*~ 
