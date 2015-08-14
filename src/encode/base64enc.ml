open Cmdliner
open Common

let b64enc encode infile =
  let coding = match encode with
  | E -> Nocrypto.Base64.encode
  | D -> Nocrypto.Base64.decode in
(Cstruct.to_string (coding (Cstruct.of_string (readfile infile)))^"\n")

let splitting str m = 
  let rec aux str n acc = function
    | 0 -> acc 
    | _ -> if (String.length str) >= m 
    then aux (Str.string_after str n) n ((Str.string_before str n)::acc) (String.length(Str.string_after str n))
    else (str::acc) in 
  List.rev (aux str m [] (String.length str))

let concatstrlist l str =
  let rec aux acc str = function
    | [] -> acc
    | hd::tl -> aux (hd^str^acc) str tl in
  aux "" str (List.rev l)

let base64enc encode infile outfile=
  savefile outfile (concatstrlist (splitting (b64enc encode infile) 64) "\n") 
(*
let base64enc encode infile outfile =
  savefile outfile (b64enc encode infile)
*)
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

