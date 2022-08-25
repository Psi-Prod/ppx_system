type t = Darwin | FreeBSD | NetBSD | OpenBSD | Unix | Win32

let to_string = function
  | Darwin -> "Darwin"
  | FreeBSD -> "FreeBSD"
  | NetBSD -> "NetBSD"
  | OpenBSD -> "OpenBSD"
  | Unix -> "Unix"
  | Win32 -> "Win32"

let get () =
  if Sys.win32 then Ok Win32
  else
    match Uname.sysname () with
    | "Darwin" -> Ok Darwin
    | "FreeBSD" -> Ok FreeBSD
    | "Linux" -> Ok Unix
    | "NetBSD" -> Ok NetBSD
    | "OpenBSD" -> Ok OpenBSD
    | sys_name -> Error sys_name
