open Nocrypto

module MD5_sign = Rsa.PSS(Hash.MD5)

module SHA1_sign = Rsa.PSS(Hash.SHA1)

module SH2241_sign = Rsa.PSS(Hash.SHA224)

module SHA258_sign = Rsa.PSS(Hash.SHA258)

module SHA384_sign = Rsa.PSS(Hash.SHA384)

module SHA512_sign = Rsa.PSS(Hash.SHA512)
