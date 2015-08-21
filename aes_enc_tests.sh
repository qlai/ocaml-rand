#!/bin/bash -x

# $1 key; $2 input file

# encode/decode test
echo "tests for ctr and cbc encoding and decoding"
echo "please enter key for test"
read keyinput
echo "please enter input file for test"
read fileinput

modes='./aes_ctr.byte ./aes_cbc.byte'

for mode in $modes
do
  $mode -k $keyinput --in $fileinput --out out.tmp1

  $mode -d -k $keyinput --in out.tmp1 --out out.tmp2

  diff out.tmp2 $fileinput;
  test=$?;
  if [ "$test" -eq 0 ] 
  then echo "decoded encode file successfully for" $mode
  else echo "decoding failed for" $mode 
  fi
done
exit 0
