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
#require "hex";;

(*implementation*)

type encoding = Base64 | Hex | NoEncoding

let encode_str = function Base64 -> "base64" | Hex -> "hex" | NoEncoding -> "noencoding"

let rand outfile randseed encode = 

let read_file filename = 
	let chan = open_in filename in
	Std.input_list chan

let inputseed = read_file randseed in
(*TO DO: feed seed into PRNG*)

let generatedRand = 
	match seed with
		|"noseed" -> Nocrypto.Rng.generate (*TO DO: use nocrypto lib generate pseudo rand*)
		| _ -> Nocrypto.Rng.create ~seed:inputseed

let encodedRand = 
	match encode with
		| "base64" -> Nocrypto.Base64.encode generatedRand(*TO DO: use nocrypto to encode randbytes with base 64*)
		| "hex" -> Hex.of_string generatedRand (*hex encoding of randbytes*)
		| "noencoding" -> generatedRand


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
	let doc = "user provide seed" in
	Arg.(value & opt string "noseed" & info ["randseed"] ~doc)

let encode = 
	let doc = "perform base64/PEM encoding" in
	let base64 = Base64, Arg.info ["base64"; "pem"] ~doc in
	let doc = "perform hex encoding" in 
	let hex = Hex, Arg.info ["hex"] ~doc in
	let doc = "neither base64 or hex encoding required" in
	let noencoding = NoEncoding, Arg.info ["none";"noencoding"] ~doc in 
	Arg.(last & vflag_all [NoEncoding] [base64; hex; noencoding])

let cmd =
	let doc = "rand" in
	let man = [
	`S "BUGS";
	`P "Email to <giulia.lai@gmail.com>." ] in
Term.(ret (pure rand $ outfile $ randseed $ encode)),
Term.info "rand" ~version:rand_version.currentversion ~doc ~man

let () = match Term.eval cmd with
`Error _ -> exit 1 | _ -> exit 0
