#!/bin/bash

COMMAND=$1
PARAMETERS="${@:2}"

cd /tmp

case $COMMAND in

  gcc)
    m68k-atari-mint-gcc $PARAMETERS
    ;;

  vasm)
    vasmm68k_mot $PARAMETERS
    ;;

  vlink)
    vlink $PARAMETERS
    ;;

  bash)
    bash $PARAMETERS
    ;;

  *)
    echo "Available commands are":
    echo "- gcc: compiles C code into Atari ST TOS and GEM"
    echo "- vasm: compiles M68K code into Atari ST TOS and GEM"
    echo "- vlink: link object files into Atari ST executables"
    echo ""
    echo "Don't forget to set up the WORKING_FOLDER environment variable pointing to the"
    echo "absolute path of your working folder."
    ;;
esac
