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

Five system are supported: **Darwin**, **UNIX**, **Win32**, **FreeBSD**, **NetBSD**, **OpenBSD**.

Assuming you are on **UNIX**:
```ocaml
# #require "ppx_system";;
# Printf.sprintf "You are on %s!"
    [%system
      {
        darwin = "Darwin";
        free_bsd = "FreeBSD";
        net_bsd = "NetBSD";
        open_bsd = "OpenBSD";
        unix = "UNIX";
        win32 = "Win32"
      }]
- : string = "You are on UNIX!"
```

```ocaml
# #require "ppx_system";;
# [%system { darwin = "open"; unix = "xdg-open" }];;
- : string = "xdg-open"
```

Use the `default` field to set a default value if your system is not precised:
```ocaml
# [%system { free_bsd = "On FreeBSD"; default = "Not on FreeBSD" }];;
- : string = "Not on FreeBSD"
```

## Contributing

Pull requests, bug reports, and feature requests are welcome.

## License

- **GPL 3.0** or later. See [license](LICENSE) for more information.
