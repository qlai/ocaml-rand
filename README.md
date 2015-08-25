# ocaml-rand

## About

Some simple utilities for doing OpenSSL Tasks.

* `rand` PRNG, outputs in specified file with no encoding, base 64 encoding or hex encoding (can also be seeded with txt file seed).
* `base64` performs base64 encoding or decoding on given file and outputs to specified file.
* tools beginning in `aes` perform aes encrytion/decrytion under given modes. (currently available: ctr, cbc - underconstruction with padding)
* `dgst` produces digests for given input file but with fewer hash functions, and can sign/verify with PEM encoded keys.

## Dependencies

Dependent on `x509`, `nocrypto`, `hex` libraries. Command-line interface generated using the latest release of `cmdliner`. Also requires `hex`, `cstruct` and `extlib`.
These can all be installed using `opam` (although some may need to be pinned to main repos).

```
opam pin add "package" https://github.com/packagelink.git
opam install nocrypto x509 cstruct cmdliner extlib
```

## Using the Tools
* this small set of tools has not yet been packaged so please fork and clone via github
* `cd ocaml-rand` on terminal and enter run `oasis setup` and `make` to build byte files.
* run the test files to check they are working, or submit issue here if any error occur

>### rand.byte
>#### Name 
>pseudo random number generator
>#### Synopsis
>./dgst.byte [--out filename] [--seed filename] [--base64|--hex|--none] ([--NoOfBits])
>#### Description
>Generates a string of pseudorandom bytes using [`Nocrypto`](https://github.com/mirleft/ocaml-nocrypto)
>#### Options
>--out filename
>  write prn in file
>--seed filename
>  use a file to seed the prng
>--base64/--hex
>  hex or base64 encoding for the output
>(--NoOfBits can only be changed in the code manually)

### ============

>### dgst.byte
>#### Name
>md5, sha1, sha244, sha256, sha384, sha512 message digests (default = md5)
>#### Synopsis
>./dgst.byte [--md5|--sha1|--sha244|--sha256|--sha384|--sha512] [-c] [-r] [--hex|--binary] [--in filename] [--out filename] >[--hmac key] [--sign filename] [--verify filename] [--prverify filename] [--signature filename]
>#### Description
>Outputs message digests of supplied file in hexdecimal. Can also be used to generate and verify digital signatures using digests.
>#### Options
>--c
>  print out the digest in two digit groups separated by colons, only relevant if hex format output is used.
>--hex/--binary
>  output the digest or signature in hex or binary form. Defaults as hex.
>--r
>  output the digest in the "coreutils" format used by programs like sha1sum.
>--out filename
>  filename to output to, or standard output by default. Have this tested and working for txt format only (e.g. --out filename.txt).
>--in filename
>  for file where the msg is, same format as --out.
>--sign filename
>  digitally sign the digest using the private key in "filename", only in PEM format (e.g. prkey.pem, but enter 'prkey').
>--verify filename
>  verify the signature using the the public key in "filename". The output is either "Verification OK" or "Verification Failure". Same format as --sign.
>--prverify filename
>  verify the signature using the the private key in "filename". Same format as --sign.
>--signature filename
>  the actual signature to verify, same format as --out.
>--hmac key
>  create a hashed MAC using "key", to be entered by hand in string format.
>#### Examples
>* To create a binary digest `./dgst.byte --in message.txt --binary`
>* To get HMAC `./dgst.byte --sha1 --hmac "thisismyHMACkey" --in message.txt --out msgdgst.txt`
>* To sign a file `./dgst.byte --sha244 --sign prkey --in message.txt --out signed.txt`

### ============

>### aes_ctr.byte
>#### Name 
>AES_CTR encoding and decoding tool
>#### Synopsis
>./aes_ctr.byte [-e|-d] [--key yourkey|--keyfile keyfile] [--in filename] [--out filename] 
>#### Options
>-e/-d
>  choose to encode or decode, defaults as encode
>--key filename / --keyfile keyfile
>  manually enter key as string or use the key in a file (tested and working with txt at the moment only)
>--in and --out -> see for dgst

### ============

>### base64enc.byte
>#### Name
>Base64 encoding and decoding tool
>#### Synopsis
>./base64enc.byte [-e|-d] [--in filename] [--out filename]
>#### Options
>see aes_ctr and dgst

## Notes
I am still working on the tools so this hasn't been packaged properly yet. However any feedbacks/suggestions are always welcome :) 
