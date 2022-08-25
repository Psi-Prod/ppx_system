(* Written to work on Linux. *)

assert (match [%get_system] with Unix -> true | _ -> false);

assert (String.equal "xdg-open" [%system { unix = "xdg-open" }]);

assert (
  String.equal "UNIX"
    [%system
      {
        darwin = "Darwin";
        free_bsd = "FreeBSD";
        net_bsd = "NetBSD";
        open_bsd = "OpenBSD";
        unix = "UNIX";
        win32 = "Win32";
      }]);

assert (String.equal "open" [%system { default = "open" }]);

assert (
  String.equal "xdg-open" [%system { darwin = "open"; default = "xdg-open" }]);

assert (
  String.equal "xdg-open"
    [%system { darwin = "open"; unix = "xdg-open"; win32 = "open" }])
