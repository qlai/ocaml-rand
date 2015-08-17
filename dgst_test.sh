#!/bin/bash 

# $1 input file

# hmac tests

hashfuncs='md5 sha1 sha224 sha256 sha384 sha512'

for hashfun in $hashfuncs
do
  openssl dgst -$hashfun -hmac "helloworld" -out out.tmp1 $1
  ./dgst.byte --$hashfun --hmac "helloworld" --out out.tmp2 --in $1
  diff out.tmp1 out.tmp2;
  test=$?;
  if [ "$test" -eq 0 ];
  then 
    echo $hashfun "hmac test passed"
  else
    echo $hashfun "hmac test failed"
  fi
done

codetype='hex binary'
for coding in $codetype
do
  openssl dgst -$coding -out out.tmp3 $1
  ./dgst.byte --$coding --out out.tmp4 --in $1
  diff out.tmp3 out.tmp4;
  test2=$?;
  if [ "$test2" -eq 0 ];
  then 
    echo $coding "test passed"
  else
    echo $coding "test failed"
  fi
done

rm out.tmp1;
rm out.tmp2;
rm out.tmp3;
rm out.tmp4;

exit 0
