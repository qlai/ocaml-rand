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
      
let infile =
  let doc = "filein" in
  Arg.(value & opt string "infile.txt" & info ["i"; "in"] ~doc)

let outfile =
  let doc = "fileout" in
  Arg.(value &opt string "outfile.txt" & info ["o"; "out"] ~doc)
