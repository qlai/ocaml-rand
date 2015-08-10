open Nocrypto
open X509

let cs_mmap file =
  Unix_cstruct.of_fd Unix.(openfile file [O_RDONLY] 0)

let load file =
  cs_mmap (file^".pem")

let sigencode keyfile msg = 
  let key = match Encoding.Pem.Private_key.of_pem_cstruct1 (load keyfile) with
  |`RSA x -> x in
  Rsa.PKCS1.sig_encode ~key:key msg
  
let sigdecode keyfile signature =
  let key = match Encoding.Pem.Public_key.of_pem_cstruct1 (load keyfile) with
  | `RSA x -> x
  | `EC_pub x-> failwith "RSA required" in
  match Rsa.PKCS1.sig_decode ~key:key signature with
  | Some x -> x
  | None -> failwith "signature invalid"

let encryptmsg keyfile msg =
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
    | Some x -> x
  
  
