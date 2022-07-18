open Ppxlib

type options = {
  darwin : string;
  free_bsd : string;
  net_bsd : string;
  open_bsd : string;
  unix : string;
  win32 : string;
}

type system = Darwin | FreeBSD | NetBSD | OpenBSD | Unix | Win32

let deriver = "system"
let legal_options = "{ sys_name = string_litteral; ... }"

let supported_system =
  [ "default"; "darwin"; "free_bsd"; "net_bsd"; "open_bsd"; "unix"; "win32" ]

let get_system () =
  if Sys.win32 then Ok Win32
  else
    match Uname.sysname () with
    | "Darwin" -> Ok Darwin
    | "FreeBSD" -> Ok FreeBSD
    | "Linux" -> Ok Unix
    | "NetBSD" -> Ok NetBSD
    | "OpenBSD" -> Ok OpenBSD
    | sys_name -> Error sys_name

let find_field_value fields name ~default =
  let value = ref default in
  List.iter
    (function
      | ( { txt = Lident n; _ },
          { pexp_desc = Pexp_constant (Pconst_string (v, _, _)); _ } )
        when String.equal n name ->
          value := v
      | _ -> ())
    fields;
  !value

let parse_options expr =
  match expr.pexp_desc with
  | Pexp_record (fields, _) ->
      List.iter
        (function
          | ( { txt = Lident field; loc },
              { pexp_desc = Pexp_constant (Pconst_string _); _ } ) ->
              if not (List.mem field supported_system) then
                Location.raise_errorf ~loc "%s does not support option %s"
                  deriver field
          | _ ->
              Location.raise_errorf ~loc:expr.pexp_loc
                "%s support only option of form %s" deriver legal_options)
        fields;
      let default = find_field_value fields "default" ~default:"" in
      let darwin = find_field_value fields "darwin" ~default in
      let free_bsd = find_field_value fields "free_bsd" ~default in
      let net_bsd = find_field_value fields "net_bsd" ~default in
      let open_bsd = find_field_value fields "open_bsd" ~default in
      let unix = find_field_value fields "unix" ~default in
      let win32 = find_field_value fields "win32" ~default in
      { darwin; free_bsd; net_bsd; open_bsd; unix; win32 }
  | _ ->
      Location.raise_errorf ~loc:expr.pexp_loc "A record of form %s is expected"
        legal_options

let expand ~ctxt env_expr =
  let system = parse_options env_expr in
  let str =
    match get_system () with
    | Ok Darwin -> system.darwin
    | Ok FreeBSD -> system.free_bsd
    | Ok NetBSD -> system.net_bsd
    | Ok OpenBSD -> system.open_bsd
    | Ok Unix -> system.unix
    | Ok Win32 -> system.win32
    | Error sys_name ->
        Location.raise_errorf ~loc:env_expr.pexp_loc "Unsupported system : %S"
          sys_name
  in
  let loc = Expansion_context.Extension.extension_point_loc ctxt in
  Ast_builder.Default.estring ~loc str

let extension =
  Extension.V3.declare deriver Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    expand

let rule = Context_free.Rule.extension extension
let () = Driver.register_transformation ~rules:[ rule ] "ppx_system"
