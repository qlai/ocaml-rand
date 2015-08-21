#!/bin/bash -x

# $1 key; $2 input file

# encode/decode test

modes='./aes_ctr.byte ./aes_cbc.byte'

for mode in $modes
do
  $mode -k $1 --in $2 --out out.tmp1

  $mode -d -k $1 --in out.tmp1 --out out.tmp2

  diff out.tmp2 $2;
  test=$?;
  if [ "$test" -eq 0 ] 
  then echo "decoded encode file successfully for" $mode
  else echo "decoding failed for" $mode 
  fi
done
exit 0
