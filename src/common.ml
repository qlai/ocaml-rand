open Cmdliner

let savefile afile thingtobesaved =
  let channel = open_out afile in
  output_string channel thingtobesaved;
  close_out channel 

let readfile bfile =
  let channel = open_in bfile in
  Std.input_all channel
  
let explode s =
  let rec expl i l =
    if i < 0 then l else
    expl (i - 1) (s.[i] :: l) in
  expl (String.length s - 1) [];;

let implode l =
  let result = Bytes .create (List.length l) in
  let rec imp i = function
  | [] -> result
  | c :: l -> result.[i] <- c; imp (i + 1) l in
  imp 0 l;;

let infile =
  let doc = "filein" in
  Arg.(value & opt string "infile.txt" & info ["i"; "in"] ~doc)

let outfile =
  let doc = "fileout" in
  Arg.(value &opt string "outfile.txt" & info ["o"; "out"] ~doc)
