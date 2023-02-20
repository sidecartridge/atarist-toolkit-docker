OUT = build/hello.tos
VASM_FLAGS = -Felf
VASM = vasm
VLINK = vlink
ODIR = obj
SDIR = src

_OBJS = hello.o

OBJS = $(patsubst %,$(ODIR)/%,$(_OBJS))

$(ODIR)/%.o: $(SDIR)/%.s
	$(VASM) $^ -o $@ $(VASM_FLAGS)

.PHONY: build
build: $(OBJS)
	$(VLINK) $^ -bataritos -o $(OUT)

.PHONY: clean
clean:
	rm -f $(ODIR)/* $(OUT)
