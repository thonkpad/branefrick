open Core
open Branefrick

let filter_bf code =
  String.filter code ~f:(fun c -> String.contains "><+-.,[]" c)

let run filename =
  let code = In_channel.read_all filename in
  let bf_code = filter_bf code in
  ignore @@ Evalbf.interpret bf_code

let command =
  Command.basic ~summary:"Evaluate Brainfuck from a file"
    ( Command.Param.(anon ("filename" %: string))
    |> Command.Param.map ~f:(fun filename -> fun () -> run filename) )

let () = Command_unix.run command
