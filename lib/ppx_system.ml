open Ppxlib

type options = { darwin : string; unix : string; win32 : string }
type system = Darwin | OtherUnix | Win32

let deriver = "system"
let legal_options = "{ sys_name = string_litteral; ... }"

let get_system () =
  if Sys.win32 then Ok Win32
  else
    let inc = Unix.open_process_in "uname" in
    let sys =
      match input_line inc with
      | "Darwin" -> Ok Darwin
      | "Linux" -> Ok OtherUnix
      | os_name -> Error os_name
    in
    let _ = Unix.close_process_in inc in
    sys

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
              if not (List.mem field [ "default"; "darwin"; "unix"; "win32" ])
              then
                Location.raise_errorf ~loc "%s does not support option %s"
                  deriver field
          | _ ->
              Location.raise_errorf ~loc:expr.pexp_loc
                "%s support only option of form %s" deriver legal_options)
        fields;
      let default = find_field_value fields "default" ~default:"" in
      let darwin = find_field_value fields "darwin" ~default in
      let unix = find_field_value fields "unix" ~default in
      let win32 = find_field_value fields "win32" ~default in
      { darwin; unix; win32 }
  | _ ->
      Location.raise_errorf ~loc:expr.pexp_loc "A record of form %s is expected"
        legal_options

let expand ~ctxt env_expr =
  let system = parse_options env_expr in
  let str =
    match get_system () with
    | Ok Darwin -> system.darwin
    | Ok OtherUnix -> system.unix
    | Ok Win32 -> system.win32
    | Error os_name ->
        Location.raise_errorf ~loc:env_expr.pexp_loc "Unsupported system : %S"
          os_name
  in
  let loc = Expansion_context.Extension.extension_point_loc ctxt in
  Ast_builder.Default.estring ~loc str

let extension =
  Extension.V3.declare deriver Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    expand

let rule = Context_free.Rule.extension extension
let () = Driver.register_transformation ~rules:[ rule ] "ppx_system"
