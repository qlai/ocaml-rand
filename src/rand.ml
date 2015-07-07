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
type encoding = base64 | hex

(*implementation*)
let rand outfile randseed encode = 

let read_file filename = 
	let chan = open_in filename in
	Std.input_list chan

let seed = read_file randseed in
(*TO DO: feed seed into PRNG*)

let generatedRand = Nocrypto.rng.generate (*TO DO: use nocrypto lib generate pseudo rand*)

let encodedRand = 
	match encode with
		| "base64" -> Nocrypto.base64.encode generatedRand(*TO DO: use nocrypto to encode randbytes with base 64*)
		| "hex" -> Hex.of_string generatedRand (*hex encoding of randbytes*)
		| "NoEncoding" -> generatedRand


let save file string =
let channel = open_out file in
output_string channel string;
close_out channel;;

let outputfile =
	match outfile with
		| Some x -> save x encodedRand
		| "NoOutput" -> print_endline encodedRand

print_endline "execution complete"

(* commandline interface*)

open Cmdliner;;

let outfile =
	let doc = "Write to file instead of standard output." in
	Arg.(value & opt string "NoOutput" & info ["out"; "outfile"] ~doc)

let randseed = 
	let doc = "to be added" in
	Arg.(value & opt string "file for rand seed" & info ["randseed"] ~doc)

let encode = 
	let doc = "perform base64 or hex encoding on output" in
	Arg.(value & pos 0 string "NoEncoding" & info ["encoding"] ~doc)

let cmd =
	let doc = "rand" in
	let man = [
	`S "BUGS";
	`P "Email to <giulia.lai@gmail.com>." ] in
Term.(ret (pure rand $ outfile $ randfile $ base $ hex)),
Term.info "rand" ~version:"0.0" ~doc ~man

let () = match Term.eval cmd with
`Error _ -> exit 1 | _ -> exit 0
