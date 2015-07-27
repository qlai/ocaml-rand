open Cmdliner
open Common
open Nocrypto
open Hash
open ExtLib

(*need function to choose digests*)

type digest = 
  | MD5 | SHA1 | SHA224 | SHA256 | SHA384 | SHA512

type enc =
  | HEX | BINARY | NOENCODE

type cmode =
  | CEn | CDi

let digest = MD5 
let encode = HEX
let outfile = "somefile.txt"
let msg = "helloworld"
let key = Cstruct.of_string "somekey"


let cdisp somehex =
  let addsemi somelist = 
    let rec aux count acc = function
    |[] -> acc
    | hd :: tl -> if count = 2 
                  then aux 0 (';'::acc) (hd::tl) 
                  else aux (count + 1) (hd::acc) tl in
    List.rev(aux 0 [] somelist) in
  let tostring =
    match somehex with | `Hex(str) -> str | _ -> failwith "not Hex.t" in
  ExtLib.String.implode (addsemi (ExtLib.String.explode tostring))

let tobinary str =
  let rec strip_bits i s =
    match i with
    |0 -> s
    |_ -> strip_bits (i lsr 1) ((string_of_int (i land 0x01)) ^ s) in
  strip_bits (int_of_string str) ""

let dimsg msg digest = (*initialisation might be required*)
  match digest with 
  | MD5 -> MD5.digest (Cstruct.of_string msg)
  | SHA1 -> SHA1.digest (Cstruct.of_string msg)
  | SHA224 -> SHA224.digest (Cstruct.of_string msg)
  | SHA256 -> SHA256.digest (Cstruct.of_string msg)
  | SHA384 -> SHA384.digest (Cstruct.of_string msg)            
  | SHA512 -> SHA512.digest (Cstruct.of_string msg)
  
let decide cmode msg digest= 
  match cmode with
  | CEn -> savefile outfile (cdisp (Hex.of_cstruct (dimsg msg digest)))
  | CDi -> Hex.hexdump (Hex.of_cstruct (dimsg msg digest))
  
let gethmac key msg digest= 
  match digest with
  | MD5 -> MD5.hmac key (Cstruct.of_string msg)
  | SHA1 -> SHA1.hmac key (Cstruct.of_string msg)
  | SHA224 -> SHA224.hmac key (Cstruct.of_string msg)
  | SHA256 -> SHA256.hmac key (Cstruct.of_string msg)
  | SHA384 -> SHA384.hmac key (Cstruct.of_string msg)
  | SHA512 -> SHA512.hmac key (Cstruct.of_string msg)

let encoded encode cmode msg digest = 
  match encode with
  | NOENCODE -> savefile outfile (Cstruct.to_string (dimsg msg digest))
  | HEX -> decide cmode (Cstruct.to_string(dimsg msg digest)) digest
  | BINARY -> savefile outfile (tobinary msg)

let dgst digestmode encode c hmac key outfile infile =
  encoded encode c (readfile infile) digestmode;
  print_endline (Cstruct.to_string (gethmac (Cstruct.of_string key) (readfile infile) digestmode))



(*commandline interface*)

let digest = 
  let doc = "MD5 hash function" in
  let md5 = MD5, Arg.info ["md5"] ~doc in
  let doc = "SHA1 hash function" in
  let sha1 = SHA1, Arg.info ["sha1"] ~doc in
  let doc = "SHA224 hash function" in
  let sha224 = SHA224, Arg.info["sha224"] ~doc in
  let doc = "SHA384 hash function" in
  let sha384 = SHA384, Arg.info["sha284"] ~doc in
  let doc = "SHA512 hash function" in
  let sha512 = SHA512, Arg. info["sha512"] ~doc in
  Arg.(last & vflag_all [MD5] [md5; sha1; sha224; sha384; sha512])


let encode =
  let doc = "No encoding" in
  let none = NOENCODE, Arg.info["noenc"] ~doc in
  let doc = "Hex encoding" in
  let hex = HEX, Arg.info["hex"] ~doc in
  let doc = "Binary encoding" in
  let binary = BINARY, Arg.info ["binary"] ~doc in
  Arg.(non_empty & vflag_all [NOENCODE] [none; hex; binary])
