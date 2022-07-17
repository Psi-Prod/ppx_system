exception Uname_error

let () = Callback.register_exception "uname_exn_error" Uname_error

external sysname : unit -> string = "sysname"
