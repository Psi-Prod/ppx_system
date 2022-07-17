(lang dune 3.3)

(version 1.0)

(name ppx_system)

(license "GPL-3.0")

(authors "The ppx_system programmers")

(maintainers "tim.arnouts@protonmail.com")

(source
 (github Psi-Prod/ppx_system))

(homepage "https://github.com/Psi-Prod/ppx-system")

(generate_opam_files true)

(package
 (name ppx_system)
 (synopsis
  "A ppx that allows to generate a different string depending on the operating system used")
 (depends ocaml dune ppxlib))
