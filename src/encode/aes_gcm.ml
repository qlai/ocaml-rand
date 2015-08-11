open Cmdliner
open Common
open Nocrypto
open Cipher_block

let () = Nocrypto_entropy_unix.initialize () 

let aesgcm encode yourkey keyfile ivfile adata infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey yourkey (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let key = (padding getkey) |> Cstruct.of_string |> AES.GCM.of_secret in
  let iv = 
    if ivfile != "NA"
    then createiv ivfile 
    else createiv getkey in
  let result = 
  match encode, adata with 
  | E, "NA" -> AES.GCM.encrypt ~key:key ~iv:iv (Cstruct.of_string(padding(readfile infile)))
  | D, "NA" ->AES.GCM.decrypt ~key:key ~iv:iv (Cstruct.of_string(padding(readfile infile)))
  | E, _ -> AES.GCM.encrypt ~key:key ~iv:iv ~adata:(Cstruct.of_string(adata)) (Cstruct.of_string(padding(readfile infile)))
  | D, _ -> AES.GCM.decrypt ~key:key  ~iv:iv ~adata:(Cstruct.of_string(adata)) (Cstruct.of_string(padding(readfile infile))) in
  let coding = match result with
  | {Nocrypto.Cipher_block.AES.GCM.message = x; tag = y} -> Cstruct.to_string x in
savefile outfile coding (*TODO: decide what to do with tag*)

  (*commandline interface start here*)

let adata =
  let doc = "authentication data" in
  Arg.(value & opt string "NA" & info ["a"; "adata"] ~doc)

let cmd =
  let doc = "aes_gcm block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aesgcm $ encode $ yourkey $ keyfile $ ivfile $ adata $ infile $ outfile),
  Term.info "aes_gcm" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
