#!/bin/bash

ulimit -t 30      # timeout
ulimit -v 1048576 # 1 GB of memory
ulimit -f 1000    # number of written files
ulimit -c 0       # no core dumps; that's slow

NUM_OK=0
NUM_TOTAL=0

for f in `ls tests/*.mml` ; do
  echo -n -e "$f:\t"
  rm -f test.xml
  if ./mml --tree -o test.xml $f &> /dev/null ; then
    size=$(wc -c < test.xml)
    if [ $size -ge 100 ]; then
      if xmllint test.xml &> /dev/null ; then
        ((++NUM_OK))
        echo "OK"
      else
        echo "FAILED XML"
      fi
    else
      echo "FAILED XML TOO SMALL"
    fi
  else
    echo "FAILED PARSER"
  fi
  ((++NUM_TOTAL))
done

echo
echo "OK Tests: $NUM_OK out of $NUM_TOTAL"
