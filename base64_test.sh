#!/bin/bash 

# $1 = infile
echo "Please enter file name to test"
read fileinput

openssl enc -base64 -in $fileinput -out out.tmp1
./base64enc.byte -e --in $fileinput --out out.tmp2
diff out.tmp1 out.tmp2;
test=$?;
openssl enc -base64 -d -in out.tmp1 -out out.tmp3
./base64enc.byte -d --in out.tmp2 --out out.tmp4
diff out.tmp3 out.tmp4;
test2=$?;
if [ "$test" -eq 0 -a "$test2" -eq 0 ];
then # Do the thing if you get correct answer
  echo "base64 test passed"
else # Do the thing if you get wrong answer
  if [ "$test" -eq 1 ]
    then 
      if [ "$test2" -eq 1 ]
      then 
        echo "base64: both enco/deco failed"
      else 
        echo "base64: decode passed, encode failed"
      fi
    else
      echo "base64: encode passed, decode failed"
    fi
fi;

rm out.tmp1;
rm out.tmp2;
rm out.tmp3;
rm out.tmp4;


exit 0
