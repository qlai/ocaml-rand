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

let finddimode digest =
  match digest with 
  |MD5 -> "MD5"
  |SHA1 -> "SHA1"
  |SHA224 -> "SHA224"
  |SHA256 -> "SHA256"
  |SHA384 -> "SHA384"
  |SHA512 -> "SHA512" 
  
let cdisp somehex =
  let addsemi somelist = 
    let rec aux count acc = function
    |[] -> acc
    | hd :: tl -> if count = 2 
                  then aux 0 (':'::acc) (hd::tl) 
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
  
let decide cmode msg = 
  match cmode with
  | CEn -> cdisp (Hex.of_cstruct (dimsg msg digest))
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
  | NOENCODE -> Cstruct.to_string (dimsg msg digest)
  | HEX -> decide cmode (Cstruct.to_string(dimsg msg digest)) digest
  | BINARY -> tobinary msg

let afterdigest infile digest msg= 
  (finddimode digest)^"("^(infile)^")="^msg
  
let coreutils infile msg = 
  msg^infile
  
let hmacformat infile digest msg =
  "HMAC"^(filedimode digest)^"("^(filename)^")="^msg
  
let checkkey key =
  match key with
  | "NA" -> failwith "no key entered"
  | _ -> key

let dgst digestmode encode c r hmac key outfile infile =
  let msgdigested = if hmac = true 
  then Cstruct.to_string (gethmac (Cstruct.of_string (checkkey key)) (readfile infile) digestmode 
  else encoded encode c (readfile infile) digestmode in
  if outfile != "NA" then savefile outfile else ();
  if hmac = true
  then print_endline (hmacformat infile digestmode msgdigested)
  else 
    if r = true 
    then print_endline (coreutils infile msgdigested)
    else print_endline (afterdigest infile digestmode msgdigested)


  (*commandline interface*)

let digestmode = 
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
  Arg.(last & vflag_all [NOENCODE] [hex; binary; none])

let c =
  let doc = "print out digest in 2 digit groups separated by semicolon if hex encoded" in
  let cen = CEn, Arg.info ["c"] ~doc in
  let doc = "no separate" in
  let cdi = CDi, Arg.info ["noc"] ~doc in
  Arg.(last & vflag_all [CDi] [cen; cdi])

let r =
  let doc = "output in coreutils format" in
  Arg.(value & flag & info ["r"] ~doc)

let hmac =
  let doc = "hmac" in
  Arg.(value & flag & info ["hmac"] ~doc)

let key =
  let doc = "key" in
  Arg.(value & opt string "NA" & info ["k"; "key"] ~doc)

let cmd = 
  let doc = "DGST" in
  let man = [`S "BUG";
  `P "submit via github";] in
  Term.(pure dgst $ digestmode $ encode $ c $ r $ hmac $ key $ outfile $ infile),
  Term.info "dgst" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with 
`Error _ -> exit 1 | _ -> exit 0


