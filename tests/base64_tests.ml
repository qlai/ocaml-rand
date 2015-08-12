open OUnit2

open Nocrypto
open Nocrypto.Uncommon

let readfile bfile =
    let channel = open_in bfile in
      Std.input_all channel

let a_ossl = readfile "docs/afile.txt"
let b_ossl = readfile "docs/bfile.txt"
let c_ossl = readfile "docs/cfile.txt"

let test1 test_ctxt = assert_equal a_ossl (Rand.b64enc E "docs/afiled.txt")
let test2 test_ctxt = assert_equal b_ossl (Rand.b64enc E "docs/bfiled.txt")
let test3 test_ctxt = assert_equal c_ossl (Rand.b64enc E "docs/cfiled.txt")

let base64suite =
    "base64_testsuite" >::: 
    [ "test1" >:: test1;
      "test2" >:: test2;
      "test3" >:: test3 ]
      
let () =
    run_test_tt_main suite
