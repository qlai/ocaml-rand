(*rand -generate pseudo-random byte
u
args
-out file
-rand file(s)  (Use specified file or files or EGD socket (see RAND_egd) for seeding the random number generator. Multiple files can be specified separated by a OS-dependent character. The separator is ; for MS-Windows, , for OpenVMS, and : for all others.)
-base64
-hex

dependencies
-nocrypto
-ocaml-hex

aim:
rand [-out OUTFILE | --outfile=OUTFILE] [-seed RANDSEED | --randseed=RANDSEED] [ENCODE]

*)
open Hex
open Cmdliner
(*implementation*)

(*
type encoding = Base64 | Hex | NoEncoding

let encode_str = function Base64 -> "base64" | Hex -> "hex" | NoEncoding -> "noencoding"

let rand outfile randseed encode = 
  let chan = open_in randseed in
  try while true do let inputseed = input_line chan in
  let generatedRand =
    match inputseed with
    |"noseed" -> Nocrypto.Rng.generate (*TO DO: use nocrypto lib generate pseudo rand*)
    | _ -> Nocrypto.Rng.create ~seed:inputseed in (*TO DO: sort out seeded generation*)
  let encodedRand = 
    match encode with
    | "base64" -> Nocrypto.Base64.encode generatedRand(*use nocrypto to encode randbytes with base 64 encoding*)
    | "hex" -> Hex.of_string generatedRand (*hex encoding of randbytes*)
    | "noencoding" -> generatedRand in
  let save file string =
    let channel = open_out file in
    output_string channel string;
    close_out channel in
  match outfile with
  | Some x -> save x encodedRand
  | "NoOutput" -> print_endline encodedRand
(* commandline interface*)

  let outfile =
  let doc = "Write to file instead of standard output." in
  Arg.(required & pos_left ~rev:true 0 (some string) file [] & info ["out"; "outfile"] ~docv:"OUTFILE" ~doc)

let randseed = 
  let doc = "user provide seed" in
  Arg.(required & pos"" & info ["seed"; "randseed"] ~docv:"RANDSEED" ~doc)

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
*)

let ()= Nocrypto_entropy_unix.initialize ()

type encode = Noencode | Base64 | Hex

let main (length:int) (encoding:encode)= 
  let bytes = Nocrypto.Rng.generate length in
  match encoding with
  |Noencode |Hex -> bytes
  |Base64 -> Nocrypto.Base64.encode bytes

let savefile afile thingtobesaved =
  let channel = open_out afile in
  output_string channel thingtobesaved;
  close_out channel 

let readfile bfile =
  let channel = open_in bfile in
  Std.input_all channel

let number = 64
let encode = Base64
let outfile = "somefile.txt"
let running () = savefile outfile (Cstruct.to_string (main number encode));;(*TODO: Sort out encoding for hex for matching case*)

let rand (aaoutfile:string) (aaseedfile:string) (encodemode:encode) (nobits:int)=
  savefile aaoutfile (Cstruct.to_string(main nobits encodemode)) 

let aaoutfile =
  let doc = "This is the file that the PRN will be written to (default=prngstring.txt" in
  Arg.(value & pos 0 string "prngstring.txt" & info [] ~doc)

let aaseedfile =
  let doc = "This will be used to seed PRNG" in
  Arg.(value & opt string "none" & info ["seedfile"] ~doc)

let encodemode = 
  let doc = "perform base64/PEM encoding" in
  let base64 = Base64, Arg.info ["base64"; "pem"] ~doc in
  let doc = "perform hex encoding" in 
  let hex = Hex, Arg.info ["hex"] ~doc in
  let doc = "neither base64 or hex encoding required" in
  let noencode = Noencode, Arg.info ["none";"noencoding"] ~doc in 
  Arg.(last & vflag_all [Noencode] [base64; hex; noencode])
 
let nobits =
  let doc = "no of bits u want this to be (default = 64)" in
  Arg.(value & opt int number & info ["NoOfBits"] ~doc)

let rand_t = Term.(pure rand $ aaoutfile $ aaseedfile $ encodemode $ nobits)

let info =
  let doc = "type rand OUTPUTFILENAME [OPTIONS]" in
  let man = [`S "BUGS"; 
  `P "email <giulia.lai@gmail.com>";] in
  Term.info "rand" ~version:"0.0.2" ~doc ~man

let () = match Term.eval (rand_t, info) with
`Error _ -> exit 1 | _ -> exit 0

