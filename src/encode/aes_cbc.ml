open Cmdliner
open Common
open Nocrypto
open Cipher_block

let createiv ivfile nobits =
  match ivfile with  
  |"NA" -> (*TODO: generate random number and save in file called ivfile*)Rng.generate (nobits/8)
  | _ -> (*TODO: seed rng from this file*)Cstruct.of_string(readfile ivfile)


let aescbc encode nobits yourkey keyfile ivfile infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey yourkey (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let iv = if ivfile != "NA" then createiv ivfile nobits else createiv getkey nobits in
  let key = getkey |> Cstruct.of_string |> AES.CBC.of_secret in
  let coding = match encode with 
  | "E" -> AES.CBC.encrypt ~key:key ~iv:iv (Cstruct.of_string(readfile infile))
  | "D" -> AES.CBC.decrypt ~key:key ~iv:iv (Cstruct.of_string(readfile infile))
  | _ -> failwith "please enter E or D" in
savefile outfile (Cstruct.to_string coding)

  (*commandline interface start here*)

let encode =
  let doc = "E or D" in
  Arg.(value & pos 0 string "E" & info [] ~doc)

let nobits =
  let doc = "number of bits" in
  Arg.(value & opt int 128 & info ["b"; "bits"] ~doc) 

let yourkey = 
  let doc = "key" in
  Arg.(value & opt string "NA" & info ["k"; "key"] ~doc)

let keyfile =
  let doc = "keyfile" in
  Arg.(value & opt string "NA" & info ["kf" ; "keyfile"] ~doc)

let ivfile =
  let doc = "ivfile" in
  Arg.(value & opt string "NA" & info ["iv"; "ivfile"] ~doc)

let cmd =
  let doc = "aes block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aescbc $ encode $ nobits $ yourkey $ keyfile $ ivfile $ infile $ outfile),
  Term.info "aes" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
