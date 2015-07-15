open Cmdliner
open Common

type mode = ECB | CBC | CTR | GCM | CCM

let readkeyfromfile (*read key from file*)

let encryption enc mode more_args = (*TODO: need more args to make this work*)
  match enc with
  | ECB -> Nocrypto.AES.ECB.encrypt 
  | CBC -> Nocrypto.AES.CBC.encrypt
  | CTR -> Nocrypto.AES.CTR.encrypt
  | GCM -> Nocrypto.AES.GCM.encrypt
  | CCM -> Nocrypto.AES.CCM.encrypt
  | _ -> failwith "invalid encrypting mode"

let decryption enc mode more_args =
  match enc with
  | ECB -> Nocrypto.AES.ECB.decrypt
  | CBC -> Nocrypto.AES.CBC.decrypt
  | CTR -> Nocrypto.AES.CTR.decrypt
  | GCM -> Nocrypto.AES.GCM.decrypt
  | CCM -> Nocrypto.AES.CCM.decrypt
  | _ -> failwith "invalid decrypting mode"

let aes encode mode key keyfile infile outfile = 
  let getkey = match (readkeyfromfile keyfile) with
  | "none" -> key (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readkeyfromfile keyfile in
  let coding = match code with 
  | "E" -> encryption args
  | "D" -> decryption args 



  (*commandline interface start here*)
