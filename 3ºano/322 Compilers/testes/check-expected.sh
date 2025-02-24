#!/bin/bash

ulimit -t 30      # timeout
ulimit -v 1048576 # 1 GB of memory
ulimit -f 1000    # number of written files
ulimit -c 0       # no core dumps; that's slow

NUM_OK=0
NUM_TOTAL=0

for f in `ls tests/*.mml` ; do
  ((++NUM_TOTAL))
  echo -n -e "$f:\t"
  rm -f test.asm test.o test.out test
  if ! ./mml -o test.asm $f &> /dev/null ; then
    echo "FAILED CODEGEN"
    continue
  fi
  if ! yasm -felf32 test.asm &> /dev/null ; then
    echo "FAILED ASSEMBLY"
    continue
  fi
  if ! ld -m elf_i386 -o test test.o -lrts -L$HOME/compiladores/root/usr/lib &> /dev/null ; then
    echo "FAILED LINKER"
    continue
  fi
  if ! ./test &> test.out ; then
    echo "FAILED EXECUTION"
    continue
  fi

  OUT=`basename -s .mml $f`
  if ! diff -q test.out tests/expected/$OUT.out &> /dev/null ; then
    echo "FAILED OUTPUT"
    diff -u test.out tests/expected/$OUT.out
    continue
  fi
  echo "OK"
  ((++NUM_OK))
done

echo
echo "OK Tests: $NUM_OK out of $NUM_TOTAL"
