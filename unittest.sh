#!/bin/bash

# $1 = infile
# $2 = infilewithbase64

openssl enc -base64 -in $1 -out out.tmp1
./base64enc.byte -e --in $1 --out out.tmp2
diff out.tmp1 out.tmp2;
test=$?;
openssl enc -base64 -d -in $2 -out out.tmp3
./base64enc.byte -d --in $2 --out out.tmp4
test2=$?;
if [ "$test" -eq 0 -a "$test2" -eq 0];
then # Do the thing if you get correct answer
  echo "Victory"
else # Do the thing if you get wrong answer
  echo "Failure"
fi;

rm out.tmp1;
rm out.tmp2;
rm out.tmp3;
rm out.tmp4;

exit 0
