open Cmdliner
open Common
open Nocrypto
open Cipher_block

let aesctr encode yourkey keyfile counter offset infile outfile = 
  let checkkey akey =
  match akey with 
  | "NA" -> failwith "no key entered"
  | _ -> akey in
  let getkey = match keyfile with
  | "NA" -> checkkey yourkey (*TODO: here we need to decide whether key is entered or read from file*)
  | _ -> readfile keyfile in
  let key = (padding getkey) |> Cstruct.of_string |> AES.CTR.of_secret in
  let ctr = Rng.generate counter in
  let coding = 
  match encode, offset with 
  | "E", 0 -> AES.CTR.encrypt ~key:key ~ctr:ctr (Cstruct.of_string(padding(readfile infile)))
  | "D", 0 ->  AES.CTR.decrypt ~key:key ~ctr:ctr (Cstruct.of_string(padding(readfile infile)))
  | "E", _ -> AES.CTR.encrypt ~key:key ~ctr:ctr ~off:offset (Cstruct.of_string(padding(readfile infile)))
  | "D", _ -> AES.CTR.decrypt ~key:key ~ctr:ctr ~off:offset (Cstruct.of_string(padding(readfile infile)))
  | _ -> failwith "please enter E or D" in
savefile outfile (Cstruct.to_string coding)

  (*commandline interface start here*)
let counter =
  let doc = "counter length" in
  Arg.(value & opt int 16 & info ["c"; "ctr"] ~doc)

let offset =
  let doc = "offset" in
  Arg.(value & opt int 0 & info ["off"; "offset"] ~doc)

let cmd =
  let doc = "aes_ctr block cipher" in
  let man = [
    `S "BUGS" ;
    `P "Submit via github"]
  in
  Term.(pure aesctr $ encode $ yourkey $ keyfile $ counter $ offset $ infile $ outfile),
  Term.info "aes_ctr" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0
