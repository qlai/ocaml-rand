#!/bin/bash

# $1 input file

# hmac tests

hashfuncs='md5 sha1 sha224 sha256 sha385 sha512'

for hashfun in $hashfuncs
openssl -dgst -$hashfun -hmac "helloworld" -out out.tmp1 $1
./dgst.byte --$hashfun --hmac "helloworld" --out out.tmp2 --in $1
diff out.tmp1 out.tmp2;
test=$?;
if [ "$test" -eq 0 ];
then 
  echo $hashfun "hmac test passed"
else
  echo $hashfun "hmac test failed"
fi

rm out.tmp1;
rm out.tmp2;

exit 0
