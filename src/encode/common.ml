open Cmdliner
open Nocrypto

type encode =
  | E | D

let savefile afile thingtobesaved =
    let channel = open_out afile in
      output_string channel thingtobesaved;
        close_out channel 

let output file msg =
  match file with
  | "NA" -> print_string msg
  | _ -> savefile file msg

let readfile bfile =
    let channel = if bfile <> "NA" then open_in bfile else failwith "no input file" in
      Std.input_all channel

let rec paddings str =
    if (String.length str) mod 16 = 0 then str else paddings (str^" ")

let createiv ivfile n =
  let g = Rng.create (module Rng.Generators.Fortuna) in 
  (match ivfile with  
  |"NA" -> Nocrypto_entropy_unix.reseed g; print_endline "warning, rand iv"
  | _ -> (*TODO: seed rng from this file*) Rng.reseed ~g (Cstruct.of_string (ivfile)) );
  Rng.generate ~g n 
  
let encode =
  let doc = "encoding" in
  let e = E, Arg.info ["e"] ~doc in
  let doc = "decoding" in 
  let d = D, Arg.info ["d"] ~doc in 
  Arg.(last & vflag_all [E] [d; e])
  
let nobits =
  let doc = "number of bits" in
  Arg.(value & opt int 128 & info ["b"; "bits"] ~doc) 
  
let yourkey = 
  let doc = "key" in
  Arg.(value & opt string "NA" & info ["k"; "key"] ~doc)

let keyfile =
  let doc = "keyfile" in
  Arg.(value & opt string "NA" & info ["kf" ; "keyfile"] ~doc)
  
let infile =
  let doc = "filein" in
  Arg.(value & opt string "NA" & info ["i"; "in"] ~doc)

let outfile =
  let doc = "fileout" in
  Arg.(value &opt string "NA" & info ["o"; "out"] ~doc)

let ivfile =
  let doc = "ivfile" in
  Arg.(value & opt string "NA" & info ["iv"; "ivfile"] ~doc)
