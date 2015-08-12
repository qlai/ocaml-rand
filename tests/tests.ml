open OUnit2

let base64suite =
    "base64_testsuite" >::: 
    [ "test1" >:: Base64_tests.test1;
      "test2" >:: Base64_tests.test2;
      "test3" >:: Base64_tests.test3 ]
      
