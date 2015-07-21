open Cmdliner
open Common
open Nocrypto
open Cipher_block

let aesccm encode yourkey keyfile nonce adata infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey yourkey (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let ckey = (padding getkey) |> Cstruct.of_string in
  let key = AES.CCM.of_secret ~maclen:16 ckey in
  let coding = 
  match (encode, adata) with 
  | ("E", "NA") -> AES.CCM.encrypt ~key:key ~nonce:nonce (Cstruct.of_string(padding(readfile infile)))
  | ("D", "NA" -> AES.CCM.decrypt ~key:key ~nonce:nonce (Cstruct.of_string(padding(readfile infile)))
  | ("E", _ ) -> AES.CCM.encrypt ~key:key ~nonce:nonce ~adata:adata (Cstruct.of_string(padding(readfile infile)))
  | ("D", _ ) -> AES.CCM.decrypt ~key:key ~nonce:nonce ~adata:adata (Cstruct.of_string(padding(readfile infile)))
  | _ -> failwith "please enter E or D" in
savefile outfile (Cstruct.to_string coding)

  (*commandline interface start here*)


let cmd =
  let doc = "aes_ccm block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aesccm $ encode $ yourkey $ keyfile $ nonce $ adata $ infile $ outfile),
  Term.info "aes_ccm" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
