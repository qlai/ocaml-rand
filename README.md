# ocaml-rand

trying to do what openssl rand does: https://www.openssl.org/docs/apps/rand.html

args
-out file
-rand file(s)
-base64
-hex

dependencies
-nocrypto
-ocaml-hex
-cmdliner

now also trying to do what openssl ciphers does: https://www.openssl.org/docs/apps/ciphers.html

args
-s -v -V -ssl3 -tls1 -stdname cipherlist

dependencies
-nocrypto
-cmdliner
