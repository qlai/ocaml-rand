(*rand -generate pseudo-random byte

args
-out file
-rand file(s)  (Use specified file or files or EGD socket (see RAND_egd) for seeding the random number generator. Multiple files can be specified separated by a OS-dependent character. The separator is ; for MS-Windows, , for OpenVMS, and : for all others.)
-base64
-hex

dependencies
-nocrypto
-ocaml-hex
*)

(*implementation*)
let rand outfile randfile base hex = 

let generatedRand = Nocrypto.rng.generate (*generate pseudo rand*)

let base_str = 
	match base with
		| "base64" -> Nocrypto.base64.encode generatedRand(*some code that encodes randbytes with base 64*)
		| "NoBase64" -> generatedRand

let hexed = 
	match hex with 
		|"hex" -> Hex.of_string base_str
		|"NoHexEncoding" -> print_endline "Not hexed"

let save file string =
let channel = open_out file in
output_string channel string;
close_out channel;;

let outputfile =
	match outfile with
		| Some x -> if hex = "hex" then save x hexed else save x base_str
		| "NoOutput" -> if hex = "hex" then print_endline hexed else print_endline base_str 

print_endline "execution complete"

(* commandline interface*)

open Cmdliner;;

let outfile =
	let doc = "Write to file instead of standard output." in
	Arg.(value & opt string "NoOutput" & info ["out"; "outfile"] ~doc)

let randfile = 
	let doc = "to be added" in
	Arg.(value & opt string "file for rand seed" & info ["randfile"] ~doc)

let base = 
	let doc = "perform base64 encoding on output" in
	Arg.(value & pos 0 string "NoBase64" & info ["b"; "base64"] ~doc)

let hex = 
	let doc = "show the output as hex string" in
	Arg.(value & pos 1 string "NoHexEncoding" & info ["hex"] ~doc)

let cmd =
	let doc = "rand" in
	let man = [
	`S "BUGS";
	`P "Email to <giulia.lai@gmail.com>." ] in
Term.(ret (pure rand $ outfile $ randfile $ base $ hex)),
Term.info "rand" ~version:"0.0" ~doc ~man

let () = match Term.eval cmd with
`Error _ -> exit 1 | _ -> exit 0
