(*  Nocrypto     Ciphers: AES, 3DES, RC4; Pubkey: RSA, DH, DSA*)

type cipher_info =
  { ciphername : string;
    protocover : string;
    keyex      : string;
    authenti   : string;
    encryp     : string;
    macalgo    : string;
  }
  
  
  ciphers = ["AES"; "3DES"; "ARC4"]
let rec  print_ciphers  = function
  | [] -> ()
  | hd::tl -> print_endline hd ; print_ciphers tl

let main () = print_ciphers ciphers;;

main ();;
