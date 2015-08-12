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
open Common
(*implementation*)

let ()= Nocrypto_entropy_unix.initialize ()

(*let gen_with param n =
  let g = Rng.create (module Rng.Generator.Fortuna) in
  ( match param with
    | `File name ->
        let content = (* read file *) in
        Rng.reseed ~g content
    | `Auto -> Nocrypto_entropy_unix.reseed g ) ;
  Rng.generate ~g n *)

type encode = Noencode | Base64 | Hex

let main (length:int) (encoding:encode)= 
  let bytes = Nocrypto.Rng.generate length in
  match encoding with
  |Noencode |Hex -> bytes
  |Base64 -> Nocrypto.Base64.encode bytes

let number = 64
let encode = Base64
let outfile = "somefile.txt"
let running () = savefile outfile (Cstruct.to_string (main number encode));;(*TODO: Sort out encoding for hex for matching case*)

let rand (aaoutfile:string) (aaseedfile:string) (encodemode:encode) (nobits:int)=
  savefile aaoutfile (Cstruct.to_string(main nobits encodemode)) 

let aaoutfile =
  let doc = "This is the file that the PRN will be written to" in
  Arg.(value & opt  string "prngstring.txt" & info ["o"; "out"] ~doc)

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
  let doc = "no of bits u want this to be" in
  Arg.(value & opt int number & info ["NoOfBits"] ~doc)

let rand_t = Term.(pure rand $ aaoutfile $ aaseedfile $ encodemode $ nobits)

let info =
  let doc = "type rand OUTPUTFILENAME [OPTIONS]" in
  let man = [`S "BUGS"; 
  `P "email <giulia.lai@gmail.com>";] in
  Term.info "rand" ~version:"0.0.2" ~doc ~man

let () = match Term.eval (rand_t, info) with
`Error _ -> exit 1 | _ -> exit 0

(*

open Nocrypto




let gen_with param n =
  ( match param with
    | `File name ->
        let content = (* read file *) in
        Rng.reseed ~g:!Rng.generator content
    | `Auto -> Nocrypto_entropy_unix.reseed !Rng.generator ) ;
  Rng.generate n

*)
