# ocaml-rand

## About

Some simple utilities for doing OpenSSL Tasks.

* `rand` PRNG, outputs in specified file with no encoding, base 64 encoding or hex encoding (can also be seeded with txt file seed).
* `base64` performs base64 encoding or decoding on given file and outputs to specified file.
* tools beginning in `aes` perform aes encrytion/decrytion under given modes. (under construction)
* `dgst` see OpenSSL docs but with fewer hash functions. (integrated verify/sign functions under construction)

## Dependencies

Dependent on `x509`, `nocrypto`, `hex` libraries. Command-line interface generated using the latest release of `cmdliner`. Also requires `hex`, `cstruct` and `extlib`.
These can all be installed using `opam` (although some may need to be pinned to main repos).

```
opam pin add "package" https://github.com/packagelink.git
opam install nocrypto x509 cstruct cmdliner extlib
```

## Notes
I am still working on the tools so this hasn't been packaged properly yet. However any feedbacks/suggestions are always welcome :) 



