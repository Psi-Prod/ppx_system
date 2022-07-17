(* Written to work on Linux. *)

assert (String.equal "xdg-open" [%system { unix = "xdg-open" }]);
assert (String.equal "open" [%system { default = "open" }]);
assert (
  String.equal "xdg-open" [%system { darwin = "open"; default = "xdg-open" }]);
assert (
  String.equal "xdg-open"
    [%system { darwin = "open"; unix = "xdg-open"; win32 = "open" }])
