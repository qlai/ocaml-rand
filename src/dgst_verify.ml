open Nocrypto
open X509
open Common

let cs_mmap file =
  Unix_cstruct.of_fd Unix.(openfile file [O_RDONLY] 0)

let load file =
  cs_mmap (file)

let sigencode prkeyfile msg outfile = 
  let key = match Encoding.Pem.Private_key.of_pem_cstruct1 (load prkeyfile) with
  |`RSA x -> x in
  let signedmsg = Cstruct.to_string (Rsa.PKCS1.sig_encode ~key:key msg) in
  if outfile <> "NA" then savefile outfile signedmsg else print_endline signedmsg
  
let sigdecode keyfile signature =
  let key = match Encoding.Pem.Public_key.of_pem_cstruct1 (load keyfile) with
  | `RSA x -> x
  | `EC_pub x -> failwith "RSA required" in
  match Rsa.PKCS1.sig_decode ~key:key signature with
  | Some x -> (Cstruct.to_string x)
  | None -> "failed - no output"

(*let encryptmsg keyfile msg =
  let key = match Encoding.Pem.Public_key.of_pem_cstruct1 (load keyfile)  with
  | `RSA x -> x 
  | `EC_pub x -> failwith "RSA required" in
  Rsa.PKCS1.encrypt ~key:key msg
  
let decryptingciph keyfile msg =
  let key = match Encoding.Pem.Private_key.of_pem_cstruct1 (load keyfile) with
  | `RSA x -> x in
  let decrmsg = Rsa.PKCS1.decrypt ~key:key msg in
  match decrmsg with
    | None -> failwith "no match"
    | Some x -> x *)
  
let prsigdecode prkeyfile signature =
  let key = match Encoding.Pem.Private_key.of_pem_cstruct1 (load prkeyfile) with
  | `RSA x -> Rsa.pub_of_priv x in
  match Rsa.PKCS1.sig_decode ~key:key signature with
  | Some x -> (Cstruct.to_string x)
  | None -> "failed - no output"
  
let comparemsg vermsg digmsg =
  match compare vermsg digmsg with 
  | 0 -> print_endline "Verification OK"
  | 1 -> print_endline "Verifiction failed"
  | _ -> failwith "compare function failure"

let signandverify sign verify prverify signature msg outfile =
  match sign, verify, prverify with 
    | "NA", "NA", "NA" -> () 
    | "NA", "NA", _ -> if signature <> "NA" 
    then comparemsg (prsigdecode prverify (Cstruct.of_string(readfile signature))) (Cstruct.to_string msg)
    else failwith "no signature file"
    | "NA", _, "NA" -> if signature <> "NA" 
    then comparemsg (sigdecode verify (Cstruct.of_string(readfile signature))) (Cstruct.to_string msg)
    else failwith "no signature file"
    | _, "NA", "NA" -> sigencode sign msg outfile
    | "NA", _, _ | _, "NA", _ | _, _, "NA" | _, _, _-> failwith "error in calling too many functions"
    

    
