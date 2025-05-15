open Base
open Stdio
open Parsebf

type 'a zipper = {left: 'a list; focus: 'a; right: 'a list}

let of_list l =
  match l with
  | [] ->
      failwith "Can't create zipper from empty list."
  | x :: xs ->
      {left= []; focus= x; right= xs}

let of_zipper z = List.rev_append z.left (z.focus :: z.right)

type direction = Left | Right

let move direction tape =
  match (direction, tape) with
  | Left, {left= _; focus= _; right= []} ->
      failwith "Already at max left bounds."
  | Left, {left= x :: xs; focus; right} ->
      {left= xs; focus= x; right= focus :: right}
  | Right, {left= _; focus= _; right= []} ->
      failwith "Already at max right bounds."
  | Right, {left; focus; right= x :: xs} ->
      {left= focus :: left; focus= x; right= xs}
  | _ ->
      failwith "Error: invalid move"

(* I think I like `move direction tape` more *)

(* let focus_right z = *)
(*   match z with *)
(*   | {left= _; focus= _; right= []} -> *)
(*       failwith "Already at max right bounds." *)
(*   | {left; focus; right= x :: xs} -> *)
(*       {left= focus :: left; focus= x; right= xs} *)

(* let focus_left z = *)
(*   match z with *)
(*   | {left= []; focus= _; right= _} -> *)
(*       failwith "Already at max left bounds." *)
(*   | {left= x :: xs; focus; right} -> *)
(*       {left= xs; focus= x; right= focus :: right} *)

let interpret cmds =
  let tape = List.init 30_000 ~f:(fun _ -> 0) |> of_list in
  let bf =
    Angstrom.parse_string ~consume:All program cmds
    |> function Ok l -> l | Error msg -> failwith msg
  in
  let rec scan tape bf =
    match bf with
    | [] ->
        tape
    | cmd :: rest ->
        let tape' =
          match cmd with
          | MoveLeft ->
              move Left tape
          | MoveRight ->
              move Right tape
          | Increment ->
              if tape.focus >= 255 then
                failwith "Cell exceeds maximum memory (255)"
              else {tape with focus= tape.focus + 1}
          | Decrement ->
              if tape.focus <= 0 then failwith "Cell byte cannot be < 0"
              else {tape with focus= tape.focus - 1}
          | Output ->
              printf "%c" (Char.of_int_exn tape.focus) ;
              Out_channel.flush Out_channel.stdout ;
              tape
          | Input -> (
              printf "-> " ;
              match In_channel.input_line In_channel.stdin with
              | Some line ->
                  let i = Int.of_string line in
                  if i <= 255 then {tape with focus= i}
                  else failwith "Input number must not exceed 255"
              | None ->
                  {tape with focus= 0} )
          | Loop loop_cmds ->
              let rec loop tape =
                if tape.focus = 0 then tape else loop (scan tape loop_cmds)
              in
              loop tape
        in
        scan tape' rest
  in
  scan tape bf
