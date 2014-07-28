#!/bin/bash

for i in {1..25}
do
  echo "$i"
  RND=$RANDOM
  if [ $RND -le 30000 ]; then
    wget --quiet "http://localhost"
  else
    wget --quiet "http://localhost/unknown-$RND"
  fi
  WAIT_INT="$(($RANDOM % 100000))"
  WAIT_SEC=`echo "scale=6;$WAIT_INT/100000.0" | bc`
  sleep $WAIT_SEC
done

exit 0
