(*  Nocrypto     Ciphers: AES, 3DES, RC4; Pubkey: RSA, DH, DSA*)

type protocoltype = 
  |SSLv3 | TLSv1 

type kex =
  |RSA |DSA |DH

type aut = 
  |RSA |DSA |DH

type enco = 
  | AES |DES |ARC4


type cipher_info =
  { name : string;
    protocol : string;
    kx   : string;
    au   : string;
    enc  : string;
    mac  : string;
  }

let ciphers = ["AES"; "3DES"; "ARC4"]
let rec  print_ciphers  = function
  | [] -> ()
  | hd::tl -> print_endline hd ; print_ciphers tl

let main () = print_ciphers ciphers;;

main ();;
