#!/bin/bash

echo "NOTE ALL KEYFILES ARE IN PEM, NON-KEY ARE TXT"
echo "please enter private rsa key to test"
read prkey
echo "please enter corresponding public key"
read pubkey
echo "please enter file input to test"
read infile

./dgst.byte --sign $prkey --in $infile --out out.tmp1
./dgst.byte --verify $pubkey --signature out.tmp1
./dgst.byte --prverify $prkey --signature out.tmp1
