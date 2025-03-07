open Base
open Branefrick

let () =
  let s =
    "++++++++++[>+>+++>+++++++>++++++++++<<<<-]>>>++.>+.+++++++..+++.<<++.>+++++++++++++++.>.+++.------.--------."
  in
  ignore (Evalbf.interpret s)
