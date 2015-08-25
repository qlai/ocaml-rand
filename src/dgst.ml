open Cmdliner
open Common
open Nocrypto
open Hash
open Dgst_verify
open Dgst_cmdl

(*exception Do_nothing*)

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
  
let output filename mode msg msg2 verify prverify = 
  if verify <> "NA" || prverify <> "NA" 
  then ()
  else match filename, mode with
  | "NA", HEX -> print_endline msg
  | _ , HEX -> savefile filename msg
  | "NA", BINARY -> print_endline msg2
  | _ , BINARY -> savefile filename msg2

let input filename verify prverify =
  match verify, prverify with
  | "NA", "NA" -> readfile filename
  | _, "NA" | "NA", _ | _, _ -> "no msg for verifying"

let dgst digestmode encode c r hmackey outfile infile sign verify prverify signature =
  let msgdigested = 
    if hmackey <> "NA" 
    then gethmac (Cstruct.of_string (checkkey hmackey sign)) (input infile verify prverify) digestmode encode c
    else encoded encode c (input infile verify prverify) digestmode in
  if hmackey <> "NA"
    then output outfile encode (hmacformat infile digestmode msgdigested) msgdigested verify prverify
    else 
      if r = true  && c = false 
      then output outfile encode (coreutils infile msgdigested) msgdigested verify prverify
      else output outfile encode (afterdigest infile digestmode msgdigested) msgdigested verify prverify;
    signandverify sign verify prverify signature (Cstruct.of_string msgdigested) outfile
  
  (*commandline interface*)


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


