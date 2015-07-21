open Cmdliner
open Common
open Nocrypto
open Cipher_block

let aesecb encode yourkey keyfile infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey yourkey (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let key = (padding getkey) |> Cstruct.of_string |> AES.ECB.of_secret in
  let coding = match encode with 
  | "E" -> AES.ECB.encrypt ~key:key (Cstruct.of_string(padding(readfile infile)))
  | "D" -> AES.ECB.decrypt ~key:key (Cstruct.of_string(padding(readfile infile)))
  | _ -> failwith "please enter E or D" in
savefile outfile (Cstruct.to_string coding)

  (*commandline interface start here*)


let cmd =
  let doc = "aes_ecb block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aesecb $ encode $ yourkey $ keyfile $ infile $ outfile),
  Term.info "aes_ecb" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
