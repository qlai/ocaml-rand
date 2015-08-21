#!/bin/bash 

# $1 input file

# hmac tests

hashfuncs='md5 sha1 sha224 sha256 sha384 sha512'
echo "hmac test"
echo "please enter hmac key to test"
read hmackey
echo "please enter input file to test"
read fileinput

for hashfun in $hashfuncs
do
  openssl dgst -$hashfun -hmac $hmackey -out out.tmp1 $fileinput
  ./dgst.byte --$hashfun --hmac $hmackey --out out.tmp2 --in $fileinput
  diff out.tmp1 out.tmp2;
  test=$?;
  if [ "$test" -eq 0 ];
  then 
    echo $hashfun "hmac test passed"
  else
    echo $hashfun "hmac test failed"
  fi
done

# binary and hex tests
echo "binary and hex tests"
echo "please enter input file to test"
read fileinput2

codetype='hex binary'
for coding in $codetype
do
  openssl dgst -$coding -out out.tmp3 $fileinput2
  ./dgst.byte --$coding --out out.tmp4 --in $fileinput2
  diff out.tmp3 out.tmp4;
  test2=$?;
  if [ "$test2" -eq 0 ];
  then 
    echo $coding "test passed"
  else
    echo $coding "test failed"
  fi
done

# hex with special format test
echo "test with coreutils formatting"
echo "please enter input file for test"
read fileinput3

openssl dgst -hex -r -out out.tmp5 $fileinput3
./dgst.byte --hex -r --out out.tmp6 --in $fileinput2
diff out.tmp5 out.tmp6;
test3=$?;
if [ "$test3" -eq 0 ];
then 
  echo "-r test passed for hex"
else
  echo "-r test failed for hex"
fi;


rm out.tmp?;

exit 0
