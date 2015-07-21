open Cmdliner

let savefile afile thingtobesaved =
    let channel = open_out afile in
      output_string channel thingtobesaved;
        close_out channel 

let readfile bfile =
    let channel = open_in bfile in
      Std.input_all channel

let rec padding str =
    if (String.length str) mod 16 = 0 then str else padding (str^" ")

let createiv ivfile =
  match ivfile with  
  |"NA" -> Rng.generate 16
  | _ -> (*TODO: seed rng from this file*) Cstruct.of_string (readfile ivfile)
  
let encode =
  let doc = "E or D" in
  Arg.(value & pos 0 string "E" & info [] ~doc)
  
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
  Arg.(value & opt string "infile.txt" & info ["i"; "in"] ~doc)

let outfile =
  let doc = "fileout" in
  Arg.(value &opt string "outfile.txt" & info ["o"; "out"] ~doc)

let ivfile =
  let doc = "ivfile" in
  Arg.(value & opt string "NA" & info ["iv"; "ivfile"] ~doc)
