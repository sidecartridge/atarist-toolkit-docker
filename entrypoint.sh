#!/bin/bash

COMMAND=$1
PARAMETERS="${@:2}"

cd /tmp

case $COMMAND in

  gcc)
    m68k-atari-mint-gcc $PARAMETERS
    ;;

  bash)
    bash $PARAMETERS
    ;;

  *)
    $COMMAND $PARAMETERS
    ;;
esac
