open Cmdliner

let savefile afile thingtobesaved =
  let channel = open_out afile in
  output_string channel thingtobesaved;
  close_out channel 

let readfile bfile =
  let channel = open_in bfile in
  Std.input_all channel
