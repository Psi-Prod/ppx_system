open Ppxlib

type options = { darwin : string; unix : string }
type system = Darwin | OtherUnix

let get_system =
  let inc = Unix.open_process_in "uname" in
  let sys =
    match input_line inc with
    | "Darwin" -> Darwin
    | "Linux" -> OtherUnix
    | _ -> failwith "TODO: unhandle system"
  in
  let _ = Unix.close_process_in inc in
  sys

let parse_options expr =
  match expr.pexp_desc with
  | Pexp_record
      ( [
          ( { txt = Lident "darwin"; _ },
            { pexp_desc = Pexp_constant (Pconst_string (darwin, _, _)); _ } );
          ( { txt = Lident "unix"; _ },
            { pexp_desc = Pexp_constant (Pconst_string (unix, _, _)); _ } );
        ],
        _ ) ->
      Ok { darwin; unix }
  | _ -> Error expr.pexp_loc

let expand ~ctxt env_expr =
  match parse_options env_expr with
  | Ok system ->
      let str =
        match get_system with
        | Darwin -> system.darwin
        | OtherUnix -> system.unix
      in
      let loc = Expansion_context.Extension.extension_point_loc ctxt in
      Ast_builder.Default.estring ~loc str
  | Error loc -> Location.raise_errorf ~loc "TODO"

let extension =
  Extension.V3.declare "system" Extension.Context.expression
    Ast_pattern.(single_expr_payload __)
    expand

let rule = Context_free.Rule.extension extension
let () = Driver.register_transformation ~rules:[ rule ] "ppx_system"
