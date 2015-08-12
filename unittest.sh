#!/bin/bash

# $1 = infile

openssl enc -base64 -in $1 -out out.tmp1
./base64enc.byte $1 out.tmp2
diff out.tmp1 out.tmp2;
test=$?;
if [ "$test" -eq 0 ];
then # Do the thing if you get correct answer
  echo "Victory"
else # Do the thing if you get wrong answer
  echo "Failure"
fi;

rm out.tmp1;
rm out.tmp2;

exit 0
