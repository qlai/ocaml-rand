open Rand
open OUnit2

let assert_dgst_equal a b = 
  assert_equal 
  ~ctxt: a 
  ~cmp: dgst
  ~msg: matching failed
