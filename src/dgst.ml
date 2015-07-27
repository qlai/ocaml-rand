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


let dimsg msg = (*initialisation might be required*)
  match digest with 
  | MD5 -> MD5.digest (Cstruct.of_string msg)
  | SHA1 -> SHA1.digest (Cstruct.of_string msg)
  | SHA224 -> SHA224.digest (Cstruct.of_string msg)
  | SHA256 -> SHA256.digest (Cstruct.of_string msg)
  | SHA384 -> SHA384.digest (Cstruct.of_string msg)            
  | SHA512 -> SHA512.digest (Cstruct.of_string msg)
  
let decide cmode msg = 
  match cmode with
  | CEn -> savefile outfile (cdisp (Hex.of_cstruct (dimsg msg)))
  | CDi -> Hex.hexdump (Hex.of_cstruct (dimsg msg))
  
let encoded encode cmode msg = 
  match encode with
  | NOENCODE -> savefile outfile (Cstruct.to_string (dimsg msg))
  | HEX -> decide cmode msg
  | BINARY -> failwith "haven't done this yet"


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

