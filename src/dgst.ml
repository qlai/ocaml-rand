open Cmdliner
open Common
open Nocrypto
open Hash

(*need function to choose digests*)

type digest = 
  | MD5 | SHA1 | SHA244 | SHA256 | SHA384 | SHA512

let () = (*initialisation*)
  match digest with 
  | MD5 -> MD5.init () (*this give t*)
  | SHA1 -> SHA1.init ()
  | SHA244 -> SHA44.init ()
  | SHA256 -> SHA256.init ()
  | SHA384 -> SHA384.init ()
  | SHA512 -> SHA512.init ()

let hex = 
  match hexdump with
  | "NA" -> savefile outfile encoding
  | "hex" | "Hex" | "HEX" -> savefile outfile (Hex.hexdump (Hex.of_cstruct coding))

(*commandline interface*)



