open Angstrom

type bf_command =
  | MoveRight
  | MoveLeft
  | Increment
  | Decrement
  | Output
  | Input
  | Loop of bf_command list

let move_right = char '>' *> return MoveRight

let move_left = char '<' *> return MoveLeft

let increment = char '+' *> return Increment

let decrement = char '-' *> return Decrement

let outpt = char '.' *> return Output

let inpt = char ',' *> return Input

let command : bf_command t =
  fix (fun command ->
      choice
        [ move_left
        ; move_right
        ; increment
        ; decrement
        ; outpt
        ; inpt
        ; (char '[' *> many command <* char ']' >>| fun cmds -> Loop cmds) ] )

let program = many command
