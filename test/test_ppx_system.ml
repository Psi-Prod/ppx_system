assert (
  match [%get_system] with
  | Darwin when [%system { darwin = "darwin" }] = "darwin" -> true
  | FreeBSD when [%system { free_bsd = "free_bsd" }] = "free_bsd" -> true
  | NetBSD when [%system { net_bsd = "net_bsd" }] = "net_bsd" -> true
  | OpenBSD when [%system { open_bsd = "open_bsd" }] = "open_bsd" -> true
  | Unix when [%system { unix = "unix" }] = "unix" -> true
  | Win32 when [%system { win32 = "win32" }] = "win32" -> true
  | Unknown _ when [%system { darwin = "darwin" }] = "" -> true
  | _ -> false)
