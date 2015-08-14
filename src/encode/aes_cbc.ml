open Cmdliner
open Common
open Nocrypto
open Cipher_block

let () = Nocrypto_entropy_unix.initialize () 

let aescbc encode yourkey keyfile ivfile infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey yourkey (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let iv = if ivfile != "NA" then createiv ivfile else createiv getkey in
  let key = (paddings getkey) |> Cstruct.of_string |> AES.CBC.of_secret in
  let coding = match encode with 
  | E -> AES.CBC.encrypt ~key:key ~iv:iv (Cstruct.of_string(paddings(readfile infile)))
  | D -> AES.CBC.decrypt ~key:key ~iv:iv (Cstruct.of_string(paddings(readfile infile))) in
savefile outfile (Cstruct.to_string coding)

  (*commandline interface start here*)


let cmd =
  let doc = "aes_cbc block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aescbc $ encode $ yourkey $ keyfile $ ivfile $ infile $ outfile),
  Term.info "aes_cbc" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
