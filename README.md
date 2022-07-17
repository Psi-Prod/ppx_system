# ppx_system

`ppx_system` is a syntax extension that allows to generate a different string depending on the operating system used.

## Installation

```bash
$ git clone https://github.com/Psi-Prod/ppx_system
$ opam install .
```

## Usage

Add the following stanza to your dune file:
```
(library
  ...
  (preprocess
    (pps ppx_system))
```

## Syntax

Assuming you are on **UNIX**:
```ocaml
utop # #require "ppx_system";;
utop # Printf.sprintf "You are on %s!" [%system { darwin = "Darwin"; unix = "UNIX"; win32 = "Win32" }];;
- : string = "You are on UNIX!"
```

Three system are supported: **Darwin**, **UNIX** and **Win32**.

```
utop # #require "ppx_system";;
utop # [%system { darwin = "open"; unix = "xdg-open" }];;
- : string = "xdg-open"
```

Use the `default` field to set a default value if your system is not precised:
```
utop # [%system { darwin = "foo"; default = "bar" }];;
- : string = "bar"
```

## Contributing

Pull requests, bug reports, and feature requests are welcome.

## License

- **GPL 3.0** or later. See [license](LICENSE) for more information.
