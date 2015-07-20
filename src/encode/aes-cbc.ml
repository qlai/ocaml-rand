open Cmdliner
open Common
open Nocrypto.Cipher_block

(*implementation*)
type mode = ECB | CBC | CTR | GCM | CCM

let encryption mode key ?ctr ?off ?iv ?nonce ?adata thingtobeenc = (*TODO: need more args to make this work*)
  match mode with(* 
  | ECB -> AES.ECB.encrypt(* key thingtobeenc*) 
  | CBC -> AES.CBC.encrypt(* key thingtobeenc*)
  | CTR -> AES.CTR.encrypt(* key ctr off thingtobeenc (*TODO: chcek this*)*)
  | GCM -> AES.GCM.encrypt(* key iv adata thingtobeenc*)
  | CCM -> AES.CCM.encrypt(*key nonce adata thingtobeenc*)*)
  | _ -> failwith "invalid encrypting mode"

let decryption mode key thingtobedec =
  match mode with(*
  | ECB -> AES.ECB.decrypt
  | CBC -> AES.CBC.decrypt
  | CTR -> AES.CTR.decrypt
  | GCM -> AES.GCM.decrypt
  | CCM -> AES.CCM.decrypt*)
  | _ -> failwith "invalid decrypting mode"

let aes encode mode key keyfile infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey key (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let coding = match encode with 
  | "E" -> encryption mode getkey (readfile infile)
  | "D" -> decryption mode getkey (readfile infile) in
savefile outfile coding

  (*commandline interface start here*)

let encode =
  let doc = "E or D" in
  Arg.(value & pos 0 string "E" & info [] ~doc)

let mode = 
  let doc = "block cipher options " in
  Arg.(value & opt string "NA" & info ["m"; "mode"] ~doc)

let key = 
  let doc = "key" in
  Arg.(value & opt string "NA" & info ["k"; "key"] ~doc)

let keyfile =
  let doc = "keyfile" in
  Arg.(value & opt string "NA" & info ["kf" ; "keyfile"] ~doc)

let cmd =
  let doc = "aes block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aes $ encode $ mode $ key $ keyfile $ infile $ outfile),
  Term.info "aes" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
