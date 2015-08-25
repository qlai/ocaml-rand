open Cmdliner
open Common
open Nocrypto
open Hash
open Dgst_verify

(*need function to choose digests*)
exception Do_nothing

type digest = 
  | MD5 | SHA1 | SHA224 | SHA256 | SHA384 | SHA512

type enc =
  | HEX | BINARY

let finddimode digest =
  match digest with 
  | MD5 -> "MD5"
  | SHA1 -> "SHA1"
  | SHA224 -> "SHA224"
  | SHA256 -> "SHA256"
  | SHA384 -> "SHA384"
  | SHA512 -> "SHA512" 
  
let cdisp cmode somehex =
  let addsemi somelist = 
    let rec aux count acc = function
    |[] -> acc
    | hd :: tl -> if count = 2 
                  then aux 0 (':'::acc) (hd::tl) 
                  else aux (count + 1) (hd::acc) tl in
    List.rev(aux 0 [] somelist) in
  let tostring =
    match somehex with | `Hex(str) -> str | _ -> failwith "not Hex.t" in
  if cmode = true 
  then implode (addsemi (explode tostring))
  else tostring
  
let dimsg msg digest = (*initialisation might be required*)
  match digest with 
  | MD5 -> MD5.digest (Cstruct.of_string msg)
  | SHA1 -> SHA1.digest (Cstruct.of_string msg)
  | SHA224 -> SHA224.digest (Cstruct.of_string msg)
  | SHA256 -> SHA256.digest (Cstruct.of_string msg)
  | SHA384 -> SHA384.digest (Cstruct.of_string msg)            
  | SHA512 -> SHA512.digest (Cstruct.of_string msg)
  
let gethmac key msg digest encode cmode = 
  let hmacmsg = match digest with
  | MD5 -> MD5.hmac key (Cstruct.of_string msg)
  | SHA1 -> SHA1.hmac key (Cstruct.of_string msg)
  | SHA224 -> SHA224.hmac key (Cstruct.of_string msg)
  | SHA256 -> SHA256.hmac key (Cstruct.of_string msg)
  | SHA384 -> SHA384.hmac key (Cstruct.of_string msg)
  | SHA512 -> SHA512.hmac key (Cstruct.of_string msg) in
  match encode with
  | HEX -> (cdisp cmode (Hex.of_cstruct hmacmsg))
  | BINARY -> (Cstruct.to_string hmacmsg)
let encoded encode cmode msg digest = 
  match encode with
  | HEX -> (cdisp cmode (Hex.of_cstruct (dimsg msg digest)))
  | BINARY -> (Cstruct.to_string (dimsg msg digest))

let afterdigest infile digest msg= 
  (finddimode digest)^"("^(infile)^")= "^msg^"\n"
  
let coreutils infile msg = 
  msg^" *"^infile^"\n"
  
let hmacformat infile digest msg =
  "HMAC-"^(finddimode digest)^"("^(infile)^")= "^msg^"\n"
  
let checkkey key sign =
  match key with
  | "NA" -> failwith "no key entered"
  | _ -> if sign = "NA" then key else failwith "MAC and Signing key cannot be both specified"
  
let output filename mode msg msg2 = 
  match filename, mode with
  | "NA", HEX -> print_endline msg
  | _ , HEX -> savefile filename msg
  | "NA", BINARY -> print_endline msg2
  | _ , BINARY -> savefile filename msg2

let dgst digestmode encode c r hmackey outfile infile sign verify prverify signature =
  let msgdigested = 
    if hmackey <> "NA" 
    then gethmac (Cstruct.of_string (checkkey hmackey sign)) (readfile infile) digestmode encode c
    else encoded encode c (readfile infile) digestmode in
  if hmackey <> "NA"
    then output outfile encode (hmacformat infile digestmode msgdigested) msgdigested
    else 
      if r = true  && c = false 
      then output outfile encode (coreutils infile msgdigested) msgdigested
      else output outfile encode (afterdigest infile digestmode msgdigested) msgdigested;
(*need to figure out how to deal with signing parts*)
    signandverify sign verify prverify signature (Cstruct.of_string msgdigested) outfile
  
  (*commandline interface*)

let digestmode = 
  let doc = "MD5 hash function" in
  let md5 = MD5, Arg.info ["md5"] ~doc in
  let doc = "SHA1 hash function" in
  let sha1 = SHA1, Arg.info ["sha1"] ~doc in
  let doc = "SHA224 hash function" in
  let sha224 = SHA224, Arg.info["sha224"] ~doc in
  let doc = "SHA384 hash function" in
  let sha256 = SHA256, Arg.info["sha256"] ~doc in
  let doc = "SHA256 hash function" in
  let sha384 = SHA384, Arg.info["sha384"] ~doc in
  let doc = "SHA512 hash function" in
  let sha512 = SHA512, Arg. info["sha512"] ~doc in
  Arg.(last & vflag_all [MD5] [md5; sha1; sha224; sha256; sha384; sha512])

let encode =
  let doc = "Hex encoding" in
  let hex = HEX, Arg.info["hex"] ~doc in
  let doc = "Binary encoding" in
  let binary = BINARY, Arg.info ["binary"] ~doc in
  Arg.(last & vflag_all [HEX] [binary; hex])

let c =
  let doc = "print out digest in 2 digit groups separated by semicolon if hex encoded" in
  Arg.(value & flag & info ["c"] ~doc)

let r =
  let doc = "output in coreutils format" in
  Arg.(value & flag & info ["r"] ~doc)

let hmackey =
  let doc = "flag this if hmac required and enter your key" in
  Arg.(value & opt string "NA" & info ["hmac"] ~doc)
    
let sign =
  let doc = "sign digest with private key in file; flag and enter filename (key.pem)" in 
  Arg.(value & opt string "NA" & info ["sign"] ~doc)
  
let verify =
  let doc = "verify signature with public key in file; flag and enter filename (PEM)" in 
  Arg.(value & opt string "NA" & info ["verify"] ~doc)
  
let prverify =
  let doc = "verify signature with private key in file; flag and enter filename (PEM)" in
  Arg.(value & opt string "NA" & info ["prverify"] ~doc)
  
let signature =
  let doc = "actual signature to be verified" in 
  Arg.(value & opt string "NA" & info ["signature"] ~doc)

let cmd = 
  let doc = "DGST: default function is MD5" in
  let man = [`S "BUG";
  `P "submit via github";] in
  Term.(pure dgst $ digestmode $ encode $ c $ r $ hmackey $ outfile $ infile $ sign $ verify $ prverify $ signature),
  Term.info "dgst" ~version:"0.0.1" ~doc ~man

let () = 
  Nocrypto_entropy_unix.initialize ();
  match Term.eval cmd with 
  `Error _ -> exit 1 | _ -> exit 0


