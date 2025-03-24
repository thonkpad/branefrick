{ pkgs ? import <nixpkgs> { } }:

with pkgs;

let ocamlPackages = pkgs.ocaml-ng.ocamlPackages_5_2;

in mkShell {
  nativeBuildInputs = with ocamlPackages; [
    ocaml
    findlib
    dune_3
    ocaml-lsp
    utop
    merlin
    ocp-indent
    ocamlformat
  ];

  buildInputs = with ocamlPackages; [
    angstrom
    base
    core
    core_unix
    stdio
    ppx_jane
  ];
}
