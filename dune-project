(lang dune 3.3)

(version 1.0)

(name ppx_system)

(license "GPL-3.0")

(authors "The ppx_system programmers")

(maintainers "tim.arnouts@protonmail.com")

(source
 (github Psi-Prod/ppx_system))

(homepage "https://github.com/Psi-Prod/ppx_system")

(generate_opam_files true)

(package
 (name ppx_system)
 (synopsis "A ppx to know host operating system at compile time")
 (depends ocaml dune ppxlib))
