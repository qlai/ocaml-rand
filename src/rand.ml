(*rand -generate pseudo-random byte

args
-out file
-rand file(s)
-base64
-hex

dependencies
-nocrypto
-ocaml-hex

*)


(*implementation*)
type base = base64 | None

type outfile = out | None

let rand outfile randfile base hex = 

let base_str = 
match base with
| base64 -> Nocrypto.base64.encode (*some code that encodes randbytes with base 64*)
| None -> Nocrypto.rng.generate (*some arguments*)

let hexed= 
Hex.of_string hex

let save file string =
let channel = open_out file in
output_string channel string;
close_out channel;;

let outputfile =
match out with
| out -> save outfile randbytes
| None -> print_endline outfile

print_endline hexed;;

(* commandline interface*)

open Cmdliner;;

let outfile =
	let doc = "Write to file instead of standard output." in
	Arg.(value & opt None & info ["out"; "outfile"] ~doc)

let randfile = 
	let doc = "to be added"
	Arg.(value & info ["randfile"] ~doc)

let base = 
	let doc = "perform base64 encoding on output"
	Arg.(value & opt & info ["b"; "base64"] ~doc)

let hex = 
	let doc = "show the output as hex string"
	Arg.(value & opt & info ["hex"] ~doc)

let cmd =
	let doc = "rand" in
	let man = [
	`S "BUGS";
	`P "Email to <giulia.lai@gmail.com>." ] 
	
	in
Term.(ret (pure rand $ outfile $ randfile $ base $ hex)),
Term.info "rand" ~version:"0.0" ~doc ~man

let () = match Term.eval cmd with
`Error _ -> exit 1 | _ -> exit 0
