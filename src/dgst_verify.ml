open Nocrypto
open X509

let cs_mmap file =
  Unix_cstruct.of_fd Unix(openfile file [O_RDONLY] 0)

let load file =
  cs_mmap (file^".pem")

let sigencode keyfile msg = 
  let key = Encoding.Pem.Private_key.of_pem_cstruct1 (load keyfile) in
  Rsa.PKCS1.sig_encode ~key:key msg
  
let sigdecode keyfile signature =
  let key = Encoding.Pem.Public_key.of_pem_cstruct1 (load keyfile) in
  Rsa.PKCS1.sig_decode ~key:key signature

let encryptmsg keyfile msg =
  let key = Encoding.Pem.Public_key.of_pem_cstruct1 (load keyfile) in
  Rsa.PKCS1.encrypt ~key:key msg
  
let decryptingciph keyfile msg =
  let key = Encoding.Pem.Private_key.of_pem_cstruct (load keyfile) in 
  let decrmsg = Rsa.PKCS.decrypt ~key:key msg in
  match decrmsg with
    | None -> failwish "no match"
    | Some x -> x
  
  
