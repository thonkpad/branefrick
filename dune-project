(lang dune 3.17)

(name branefrick)

(generate_opam_files true)

(source
 (github thonkpad/branefrick))

(authors "Thonkpad")

(maintainers "Thonkpad")

; (license LICENSE)

; (documentation https://url/to/documentation)

(package
 (name branefrick)
 (synopsis "Simple brainfuck interpreter written in Ocaml")
 (description
  "My attempt at writing a purely functional/immutable brainfuck interpreter and evaluator")
 (depends ocaml)
 (tags
  ("Brainfuck" "Parsing")))

; See the complete stanza docs at https://dune.readthedocs.io/en/stable/reference/dune-project/index.html
