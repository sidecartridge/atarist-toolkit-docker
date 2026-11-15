#!/bin/bash
# Release check for the toolkit image: every tool, library and documented
# workflow must still be in place. Runs as the host user, like stcmd does.
#
# Usage: tests/run.sh <image>      (or: make test)
set -u

IMAGE=${1:?usage: $0 <image>}
ROOT=$(cd "$(dirname "$0")/.." && pwd)
WORK=$(mktemp -d)
trap 'rm -rf "$WORK"' EXIT
USERFLAG="--user $(id -u):$(id -g)"
PASS=0
FAIL=0

ok()   { PASS=$((PASS+1)); echo "  ok   $1"; }
fail() { FAIL=$((FAIL+1)); echo "  FAIL $1"; [ -n "${2:-}" ] && echo "$2" | tail -5 | sed 's/^/       /'; }

# Run a shell snippet in the image (entrypoint bypassed).
in_image() { docker run --rm $USERFLAG -v "$WORK":/tmp -w /tmp --entrypoint bash "$IMAGE" -c "$1" 2>&1; }
# Run a command the way stcmd does (through the entrypoint, project at /tmp).
stcmd() { local dir=$1; shift; docker run --rm $USERFLAG -v "$dir":/tmp "$IMAGE" "$@" 2>&1; }

check() { local name=$1 out; out=$(in_image "$2") && ok "$name" || fail "$name" "$out"; }

# A TOS executable starts with the 0x601A branch header.
is_tos() { [ -f "$1" ] && [ "$(head -c2 "$1" | od -An -tx1 | tr -d ' \n')" = "601a" ]; }

echo "Testing $IMAGE"

echo "Tools"
for t in m68k-atari-mint-gcc m68k-atari-mint-as m68k-atari-mint-ld m68k-atari-mint-ar \
         vasm vasmm68k_mot vobjdump vlink \
         gcc clang make git curl rsync upx python python3 \
         autoconf automake libtoolize pkg-config zip unzip; do
  check "$t is installed" "command -v $t"
done
check "m68k-atari-mint-gcc runs" "m68k-atari-mint-gcc --version"
check "clang runs" "clang --version"
check "upx runs" "upx --version"

echo "Libraries"
check "libcmini is in /freemint/libcmini" \
  "test -f /freemint/libcmini/lib/crt0.o && test -f /freemint/libcmini/lib/libcmini.a && test -d /freemint/libcmini/include"
for l in c m gem gemma cflib ldg SDL ncurses z readline ssl crypto; do
  check "lib$l.a is installed" "test -f /usr/m68k-atari-mint/lib/lib$l.a"
done

echo "AGT"
check "AGTROOT is /agtools" '[ "$AGTROOT" = /agtools ] && test -f /agtools/makedefs && test -d /agtools/agtsys'
check "AGT binaries for this arch are executable" \
  'd=/agtools/bin/Linux/$(uname -m); for b in agtcut lz77 lzsa packwrap pcs2agi rmac zx0; do test -x $d/$b || { echo "missing $d/$b"; exit 1; }; done'
check "rmac runs" '/agtools/bin/Linux/$(uname -m)/rmac -v'

echo "README examples (through the entrypoint)"
mkdir -p "$WORK/readme"
printf '#include <stdio.h>\nint main(void){ printf("Hello\\n"); return 0; }\n' > "$WORK/readme/hello.c"
out=$(stcmd "$WORK/readme" gcc hello.c -o hello.tos) && is_tos "$WORK/readme/hello.tos" \
  && ok "stcmd gcc hello.c -o hello.tos" || fail "stcmd gcc hello.c -o hello.tos" "$out"
cp "$ROOT/demo/ASM/src/hello.s" "$WORK/readme/"
out=$(stcmd "$WORK/readme" vasm hello.s -o hello.o -Felf && stcmd "$WORK/readme" vlink hello.o -bataritos -o hello_asm.tos) \
  && is_tos "$WORK/readme/hello_asm.tos" && ok "stcmd vasm + stcmd vlink" || fail "stcmd vasm + stcmd vlink" "$out"

echo "Linking against the bundled libraries"
printf '#include <gem.h>\n#include <math.h>\n#include <zlib.h>\nint main(void){ appl_init(); appl_exit(); return (int)sqrt(4.0) + (zlibVersion() != 0); }\n' > "$WORK/readme/libs.c"
out=$(stcmd "$WORK/readme" gcc libs.c -o libs.prg -lgem -lz -lm) && is_tos "$WORK/readme/libs.prg" \
  && ok "gcc links -lgem -lz -lm" || fail "gcc links -lgem -lz -lm" "$out"

echo "Demos (stcmd make)"
for d in ASM C C_ASM C_LIBCMINI; do
  cp -R "$ROOT/demo/$d" "$WORK/$d"
  out=$(stcmd "$WORK/$d" make)
  bad=""
  for f in $(cd "$WORK/$d" && find . \( -name '*.tos' -o -name '*.prg' \)); do is_tos "$WORK/$d/$f" || bad="$bad $f"; done
  [ -n "$(cd "$WORK/$d" && find . \( -name '*.tos' -o -name '*.prg' \))" ] && [ -z "$bad" ] \
    && ok "demo/$d" || fail "demo/$d" "$out${bad:+ (not TOS:$bad)}"
done

echo "Host user inside the container"
check "git works in a repository at /tmp" \
  'mkdir g && cd g && git init -q && git -c user.email=t@t -c user.name=t commit -q --allow-empty -m t && git rev-parse HEAD'
check "zip/unzip round trip" 'echo x > a && zip -q a.zip a && rm a && unzip -q a.zip && test -f a'
check "autotools generate a configure script" \
  'mkdir at && cd at && printf "AC_INIT([t],[1])\nAM_INIT_AUTOMAKE([foreign])\nLT_INIT\nAC_CONFIG_FILES([Makefile])\nAC_OUTPUT\n" > configure.ac && touch Makefile.am && autoreconf -i >/dev/null && test -x configure'

echo
echo "$PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
