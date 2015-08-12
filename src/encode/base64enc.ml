open Cmdliner
open Common

let base64enc encode infile outfile =
  let coding = match encode with
  | E -> Nocrypto.Base64.encode
  | D -> Nocrypto.Base64.decode in
  savefile outfile (Cstruct.to_string (coding (Cstruct.of_string (readfile infile))))

 (*commandline interface*)

let cmd =
  let doc = "performs base 64 encoding and decoding" in
  let man = [
    `S "BUGS";
    `P "Submit at https://github.com/qlai/ocaml-rand"]
  in
  Term.(pure base64enc $ encode $ infile $ outfile ),
  Term.info "base64enc" ~version:"0.0.1" ~doc ~man

let () = match Term.eval cmd with `Error _ -> exit 1 | _ -> exit 0

